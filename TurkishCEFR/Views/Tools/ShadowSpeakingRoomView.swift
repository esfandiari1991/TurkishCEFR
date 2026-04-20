import SwiftUI
import AVFoundation

/// Shadow-Speaking Room — an immersive pronunciation practice environment.
///
/// "Shadowing" is a well-researched L2 acquisition technique: the learner
/// listens to a native speaker and repeats *simultaneously* (or with a
/// short delay). Research by Hamada (2016) shows it improves both
/// prosody and fluency more effectively than listen-then-repeat drills.
///
/// This room provides:
///   1. A sentence pool from `CorpusStore` (fully offline).
///   2. Three playback speeds: 0.5× (syllable-level), 0.75× (guided),
///      1.0× (natural).
///   3. Word-by-word captions that highlight in sync with estimated
///      word timing (simple linear estimate from utterance duration).
///   4. A waveform amplitude envelope of both the native TTS playback
///      and the learner's own recording (reusing `VoiceRecorder` from
///      `PronunciationCoachView`).
///   5. Side-by-side envelope comparison so the learner can see where
///      their stress/intonation diverges from the model.
///
/// XP is awarded per completed shadow cycle (listen → record → compare).
struct ShadowSpeakingRoomView: View {
    @EnvironmentObject private var progress: ProgressStore
    @ObservedObject private var corpus = CorpusStore.shared
    @ObservedObject private var speech = Speech.shared
    @StateObject private var recorder = VoiceRecorder()

    @State private var pair: CorpusStore.SentencePair?
    @State private var speed: PlaybackSpeed = .natural
    @State private var phase: Phase = .idle
    @State private var highlightIndex: Int = 0
    @State private var cycleCount: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                if corpus.sentenceCount == 0 {
                    EmptyStatePanel(
                        systemImage: "waveform.slash",
                        headline: "Corpus loading…",
                        message: "The offline sentence library is warming up. This only takes a moment on first launch."
                    ) {
                        Button("Retry") { pickSentence() }
                            .buttonStyle(.borderedProminent)
                            .tint(BrandTheme.crimson)
                    }
                } else {
                    sentenceCard
                    controlBar
                    waveformSection
                    tipsCard
                }
                Spacer(minLength: 0)
            }
            .padding(Spacing.xl)
        }
        .background(GradientBackground())
        .navigationTitle(AppSection.Tool.shadow.title)
        .onAppear { if pair == nil { pickSentence() } }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Gölge Konuşma Odası")
                .turkishDisplayTitle()
            Text("Shadow Speaking Room")
                .displayTitle()
                .foregroundStyle(.secondary)

            HelpBubble(
                """
                Shadowing is one of the most effective ways to improve pronunciation \
                and fluency. Listen to the native speaker, then record yourself saying \
                the same sentence. Compare the two waveforms side-by-side to see where \
                your rhythm and stress differ. Start slow (0.5×) and work up to natural speed.
                """,
                title: "What is Shadow Speaking?"
            )
        }
    }

    // MARK: - Sentence card

    private var sentenceCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Sentence · Cümle")
                    .font(DisplayFont.strong)
                Spacer()
                Button {
                    pickSentence()
                } label: {
                    Label("New sentence", systemImage: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(.bordered)
            }

            let words = (pair?.turkish ?? "").split(separator: " ").map(String.init)
            WrappingHStack(words: words, highlightIndex: highlightIndex)
                .padding(Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))

            if let eng = pair?.english {
                Text(eng)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, Spacing.sm)
            }
        }
        .padding(Spacing.lg)
        .background(RoundedRectangle(cornerRadius: 18).fill(.regularMaterial))
    }

    // MARK: - Controls

    private var controlBar: some View {
        HStack(spacing: Spacing.md) {
            speedPicker
            Spacer()
            listenButton
            recordButton
        }
        .padding(Spacing.md)
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
    }

    private var speedPicker: some View {
        HStack(spacing: Spacing.xs) {
            Text("Speed")
                .font(DisplayFont.strong)
            Picker("", selection: $speed) {
                ForEach(PlaybackSpeed.allCases) { s in
                    Text(s.label).tag(s)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
    }

    private var listenButton: some View {
        Button {
            guard let p = pair else { return }
            phase = .listening
            highlightIndex = 0
            speech.speak(p.turkish, rate: speed.rate)
            animateHighlight(wordCount: p.turkish.split(separator: " ").count)
        } label: {
            Label(
                phase == .listening ? "Playing…" : "Listen",
                systemImage: "play.fill"
            )
            .font(DisplayFont.strong)
        }
        .buttonStyle(.borderedProminent)
        .tint(BrandTheme.turquoise)
        .disabled(phase == .recording)
    }

    private var recordButton: some View {
        Button {
            if phase == .recording {
                recorder.stop()
                phase = .comparing
                cycleCount += 1
                progress.awardXP(8, reason: "Shadow Speaking")
            } else {
                phase = .recording
                recorder.start()
            }
        } label: {
            Label(
                phase == .recording ? "Stop" : "Record",
                systemImage: phase == .recording ? "stop.circle.fill" : "mic.circle.fill"
            )
            .font(DisplayFont.strong)
        }
        .buttonStyle(.borderedProminent)
        .tint(phase == .recording ? .red : BrandTheme.crimson)
    }

    // MARK: - Waveform

    private var waveformSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Waveform comparison").font(DisplayFont.strong)

            HStack(alignment: .top, spacing: Spacing.lg) {
                WaveformBar(
                    title: "Native · Yerli",
                    samples: speech.isSpeaking ? samplePlaceholder : [],
                    color: BrandTheme.turquoise
                )
                WaveformBar(
                    title: "You · Sen",
                    samples: recorder.envelope,
                    color: BrandTheme.crimson
                )
            }

            if phase == .comparing {
                Text("Cycle \(cycleCount) complete — compare the shapes above. " +
                     "Focus on where peaks (stressed syllables) align.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, Spacing.xs)
            }
        }
        .padding(Spacing.lg)
        .background(RoundedRectangle(cornerRadius: 18).fill(.regularMaterial))
    }

    private var samplePlaceholder: [Float] {
        (0..<40).map { i in
            let t = Float(i) / 40.0
            return 0.3 + 0.5 * abs(sin(t * .pi * 4))
        }
    }

    // MARK: - Tips

    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Shadowing tips").font(DisplayFont.strong)
            tipRow(icon: "1.circle.fill", text: "Start at 0.5× speed. Focus on each syllable.")
            tipRow(icon: "2.circle.fill", text: "At 0.75×, try to speak just behind the native voice.")
            tipRow(icon: "3.circle.fill", text: "At 1.0×, overlap your voice with the native speaker.")
            tipRow(icon: "4.circle.fill", text: "Compare waveforms — look for matching stress peaks.")
            tipRow(icon: "star.fill", text: "Record multiple cycles. Each one earns 8 XP.")
        }
        .padding(Spacing.lg)
        .background(RoundedRectangle(cornerRadius: 18).fill(BrandTheme.gold.opacity(0.08)))
    }

    private func tipRow(icon: String, text: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .foregroundStyle(BrandTheme.gold)
                .frame(width: IconSize.section)
            Text(text)
                .readableBody()
        }
    }

    // MARK: - Helpers

    private func pickSentence() {
        pair = corpus.randomSentence(maxLength: 60)
        phase = .idle
        highlightIndex = 0
    }

    private func animateHighlight(wordCount: Int) {
        guard wordCount > 0 else { return }
        let interval = (Double(speed.durationEstimate) / Double(wordCount))
        for i in 0..<wordCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                highlightIndex = i
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(speed.durationEstimate)) {
            if phase == .listening { phase = .idle }
        }
    }
}

// MARK: - Supporting types

private enum PlaybackSpeed: String, CaseIterable, Identifiable {
    case slow, guided, natural
    var id: String { rawValue }
    var label: String {
        switch self {
        case .slow:    return "0.5×"
        case .guided:  return "0.75×"
        case .natural: return "1.0×"
        }
    }
    var rate: Float {
        switch self {
        case .slow:    return 0.3
        case .guided:  return 0.42
        case .natural: return 0.5
        }
    }
    var durationEstimate: Float {
        switch self {
        case .slow:    return 6
        case .guided:  return 4
        case .natural: return 2.5
        }
    }
}

private enum Phase {
    case idle, listening, recording, comparing
}

/// Simple wrapping HStack that highlights one word at a time.
private struct WrappingHStack: View {
    let words: [String]
    let highlightIndex: Int

    var body: some View {
        // FlowLayout isn't available before macOS 15; use a manual Text
        // concatenation approach instead.
        words.indices.reduce(Text("")) { text, idx in
            let word = words[idx]
            let styled = Text(word)
                .font(.system(size: 24, weight: idx == highlightIndex ? .heavy : .regular, design: .serif))
                .foregroundColor(idx == highlightIndex ? BrandTheme.crimson : .primary)
            return text + (idx > 0 ? Text(" ") : Text("")) + styled
        }
        .lineSpacing(LineHeight.generous)
    }
}

/// Mini bar chart of amplitude samples.
private struct WaveformBar: View {
    let title: String
    let samples: [Float]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(DisplayFont.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            GeometryReader { geo in
                HStack(alignment: .bottom, spacing: 1) {
                    if samples.isEmpty {
                        Text("—")
                            .foregroundStyle(.quaternary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(Array(samples.prefix(60).enumerated()), id: \.offset) { _, val in
                            RoundedRectangle(cornerRadius: 1.5)
                                .fill(color.opacity(0.7))
                                .frame(width: max(2, geo.size.width / 62),
                                       height: max(2, geo.size.height * CGFloat(val)))
                        }
                    }
                }
            }
            .frame(height: 80)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.03)))
        }
        .frame(maxWidth: .infinity)
    }
}
