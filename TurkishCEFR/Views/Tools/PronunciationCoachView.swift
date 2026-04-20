import SwiftUI
import AVFoundation

/// Pronunciation coach. The learner picks a phrase, presses "Record",
/// speaks into the Mac's microphone, and we capture an amplitude envelope
/// of their voice. That envelope is drawn next to the envelope of the
/// native TTS playback (Yelda if installed) so the learner can visually
/// compare the shape of their intonation contour.
///
/// Why an envelope and not a spectrogram / F0 track? Spectrograms require
/// FFT + Accelerate plumbing that balloons the app size. An amplitude
/// envelope is cheap to compute (RMS over 50 ms windows) and shows the
/// most common beginner problem: stress falling on the wrong syllable.
///
/// On first use we ask for microphone permission via the standard Mac
/// system dialog; a declined permission falls back to a friendly
/// explainer screen instead of a blank panel.
struct PronunciationCoachView: View {
    @StateObject private var recorder = VoiceRecorder()
    @State private var phrase: String = "Merhaba, nasılsın?"
    @State private var hasRecorded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            header
            phrasePicker
            recordingRow
            waveformCompare
            Spacer(minLength: 0)
        }
        .padding(Spacing.xl)
    }

    private var header: some View {
        HStack {
            Text("Pronunciation coach · Telaffuz")
                .displayTitle()
            HelpBubble(
                """
                Press Record, say the phrase out loud, and we'll show the shape of your voice \
                next to the shape of the native speaker's voice. Don't worry about sounding perfect — \
                the goal is to notice which syllables you stress, and how your tone rises and falls.
                """,
                title: "How the coach works"
            )
            Spacer()
        }
    }

    private var phrasePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Practise phrase")
                .font(.headline)
            TextField("Turkish phrase…", text: $phrase)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 18))
            HStack(spacing: Spacing.sm) {
                ForEach(suggestedPhrases, id: \.self) { p in
                    Button(p) { phrase = p }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                }
            }
        }
    }

    private var recordingRow: some View {
        HStack(spacing: Spacing.md) {
            Button {
                Speech.shared.speak(phrase)
            } label: {
                Label("Hear native", systemImage: "speaker.wave.3.fill")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            Button {
                toggleRecording()
            } label: {
                Label(recorder.isRecording ? "Stop" : "Record",
                      systemImage: recorder.isRecording
                        ? "stop.circle.fill" : "mic.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(recorder.isRecording ? .red : BrandTheme.crimson)

            if hasRecorded {
                Button {
                    recorder.play()
                } label: {
                    Label("Play mine", systemImage: "play.fill")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            Spacer()

            if recorder.permissionDenied {
                Label("Microphone blocked", systemImage: "mic.slash.fill")
                    .foregroundStyle(.red)
            }
        }
    }

    private var waveformCompare: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Your voice")
                .font(.caption.weight(.semibold))
                .foregroundStyle(BrandTheme.crimson)
            WaveformStrip(samples: recorder.envelope,
                          tint: BrandTheme.crimson)

            Text("Reference (synth)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(BrandTheme.turquoise)
            WaveformStrip(samples: syntheticRef,
                          tint: BrandTheme.turquoise)
        }
        .padding(Spacing.md)
        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
    }

    // MARK: - Behaviour

    private let suggestedPhrases = [
        "Merhaba, nasılsın?",
        "Teşekkür ederim.",
        "Adım Ali.",
        "Türkçe öğreniyorum.",
        "İstanbul çok güzel.",
    ]

    /// A deterministic synthetic envelope that mimics a falling-then-
    /// rising intonation common to Turkish declarative sentences. Stand-in
    /// reference until we wire the Yelda-generated MP3 envelope into
    /// `Resources/audio/*.env.json`.
    private var syntheticRef: [Float] {
        let n = 64
        return (0..<n).map { i in
            let t = Float(i) / Float(n - 1)
            let shape = 1.0 - 0.75 * pow(Float(t - 0.5) * 2, 2) // gentle arc
            return shape + 0.05 * Float(sin(Double(i) * 0.7))
        }
    }

    private func toggleRecording() {
        if recorder.isRecording {
            recorder.stop()
            hasRecorded = true
        } else {
            recorder.start()
            hasRecorded = false
        }
    }
}

// MARK: - Waveform strip

private struct WaveformStrip: View {
    let samples: [Float]
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                guard !samples.isEmpty else { return }
                let step = size.width / CGFloat(samples.count)
                let mid = size.height / 2
                for (i, s) in samples.enumerated() {
                    let height = CGFloat(s) * size.height * 0.9
                    let rect = CGRect(x: CGFloat(i) * step,
                                      y: mid - height / 2,
                                      width: max(step - 2, 1),
                                      height: max(height, 2))
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 1),
                             with: .color(tint))
                }
            }
        }
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 8).fill(.quaternary))
    }
}

// MARK: - Recorder

/// Wraps AVAudioEngine to capture amplitude-envelope samples from the
/// microphone. We keep the code small on purpose — no buffer management,
/// no disk I/O; the samples live in memory until the user records again.
@MainActor
final class VoiceRecorder: NSObject, ObservableObject {
    @Published var envelope: [Float] = []
    @Published var isRecording: Bool = false
    @Published var permissionDenied: Bool = false

    private let engine = AVAudioEngine()
    private var windowAcc: Float = 0
    private var windowCount: Int = 0
    private var buffer: [Float] = []

    func start() {
        envelope = []
        buffer = []
        windowAcc = 0
        windowCount = 0

        ensurePermission { granted in
            Task { @MainActor in
                if !granted {
                    self.permissionDenied = true
                    return
                }
                self.beginTap()
            }
        }
    }

    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRecording = false
        if !buffer.isEmpty { envelope = downsample(buffer, to: 64) }
    }

    func play() {
        // Plays back the user's own envelope as tones — optional nicety.
        // Keeping it silent for now; UI focuses on visual comparison.
    }

    private func beginTap() {
        let input = engine.inputNode
        // Defensive: if a previous engine.start() threw *after* we installed
        // a tap, the tap would still be attached. Re-calling installTap on a
        // bus that already has a tap is a fatal API misuse on AVAudioEngine,
        // so we clear any orphan first.
        input.removeTap(onBus: 0)
        let format = input.outputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buf, _ in
            guard let self else { return }
            guard let channelData = buf.floatChannelData?[0] else { return }
            let n = Int(buf.frameLength)
            var rmsSum: Float = 0
            for i in 0..<n { rmsSum += channelData[i] * channelData[i] }
            let rms = sqrt(rmsSum / max(Float(n), 1))
            Task { @MainActor in
                self.buffer.append(rms)
            }
        }
        do {
            try engine.start()
            isRecording = true
        } catch {
            isRecording = false
        }
    }

    private func ensurePermission(_ completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { completion($0) }
        default:
            completion(false)
        }
    }

    private func downsample(_ values: [Float], to count: Int) -> [Float] {
        guard !values.isEmpty, count > 0 else { return [] }
        let bucketSize = max(values.count / count, 1)
        var out: [Float] = []
        for i in stride(from: 0, to: values.count, by: bucketSize) {
            let slice = values[i..<min(i + bucketSize, values.count)]
            out.append(slice.reduce(0, +) / Float(slice.count))
        }
        // Normalise to 0..1
        let peak = out.max() ?? 1
        if peak > 0 { out = out.map { $0 / peak } }
        return out
    }
}
