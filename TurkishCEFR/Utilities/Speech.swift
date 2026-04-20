import Foundation
import AVFoundation
import AppKit

/// Thin wrapper around AVSpeechSynthesizer with voice-selection helpers.
///
/// On macOS, premium/enhanced Turkish voices (e.g. "Yelda") have to be
/// downloaded by the user from System Settings ▸ Accessibility ▸ Spoken
/// Content ▸ System Voice ▸ Manage Voices ▸ Turkish. We pick the highest
/// quality voice automatically and remember the user's preference if they
/// override it in the Settings panel.
@MainActor
final class Speech: NSObject, ObservableObject {
    static let shared = Speech()

    private let synthesizer = AVSpeechSynthesizer()

    /// Whether the synthesizer is currently producing audio. Observable so
    /// `SpeechStopButton` can appear automatically and disappear when idle.
    @Published private(set) var isSpeaking: Bool = false

    /// A short, user-visible label describing the current utterance. Empty
    /// when the synthesizer is idle.
    @Published private(set) var nowSpeaking: String = ""

    /// Queue of pending utterances when the caller asks `speakAll`. The HUD
    /// shows how many lines are left.
    @Published private(set) var queueRemaining: Int = 0

    /// User-stored override. Empty string = auto-pick the best Turkish voice.
    static let voiceDefaultsKey = "TurkishCEFR.speech.voiceIdentifier"
    static let rateDefaultsKey  = "TurkishCEFR.speech.rate"

    private var pendingQueue: [String] = []

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Voices

    /// All Turkish voices installed on the system (any variant of tr-TR).
    var availableTurkishVoices: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.lowercased().hasPrefix("tr") }
            .sorted { lhs, rhs in
                // Premium > Enhanced > Default, then alphabetical by name.
                if lhs.quality.rank != rhs.quality.rank {
                    return lhs.quality.rank > rhs.quality.rank
                }
                return lhs.name < rhs.name
            }
    }

    var selectedVoiceIdentifier: String? {
        let id = UserDefaults.standard.string(forKey: Self.voiceDefaultsKey) ?? ""
        return id.isEmpty ? nil : id
    }

    /// The voice used when speaking — user's pick if installed and valid, else best auto-pick.
    var activeVoice: AVSpeechSynthesisVoice? {
        if let id = selectedVoiceIdentifier,
           let match = availableTurkishVoices.first(where: { $0.identifier == id }) {
            return match
        }
        return autoSelectedTurkishVoice
    }

    /// Best available Turkish voice. Prefers premium > enhanced > default,
    /// prefers Istanbul-accented names ("Yelda") where possible.
    var autoSelectedTurkishVoice: AVSpeechSynthesisVoice? {
        let voices = availableTurkishVoices
        if let istanbul = voices.first(where: { $0.name.localizedCaseInsensitiveContains("yelda") }) {
            return istanbul
        }
        return voices.first ?? AVSpeechSynthesisVoice(language: "tr-TR")
    }

    /// True if there is at least one quality-enhanced Turkish voice installed.
    var hasPremiumTurkishVoice: Bool {
        availableTurkishVoices.contains { $0.quality.rank >= AVSpeechSynthesisVoiceQuality.enhanced.rank }
    }

    // MARK: - Speak

    /// Speak a single utterance, cancelling anything already in flight.
    func speak(_ text: String, rate: Float? = nil) {
        guard !text.isEmpty else { return }
        pendingQueue.removeAll()
        queueRemaining = 0
        enqueue(text, rate: rate, clearFirst: true)
    }

    /// Speak every item in order. The HUD stop button cancels the whole queue.
    func speakAll(_ texts: [String], rate: Float? = nil) {
        let trimmed = texts.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                           .filter { !$0.isEmpty }
        guard !trimmed.isEmpty else { return }
        pendingQueue = Array(trimmed.dropFirst())
        queueRemaining = pendingQueue.count
        enqueue(trimmed.first ?? "", rate: rate, clearFirst: true)
    }

    /// Stop any in-flight speech and clear the queue.
    func stop() {
        pendingQueue.removeAll()
        queueRemaining = 0
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
        isSpeaking = false
        nowSpeaking = ""
    }

    private func enqueue(_ text: String, rate: Float?, clearFirst: Bool) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = activeVoice
        utterance.rate = rate ?? currentRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        if clearFirst, synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        nowSpeaking = String(text.prefix(80))
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    private var currentRate: Float {
        let stored = UserDefaults.standard.object(forKey: Self.rateDefaultsKey) as? Double
        return Float(stored ?? 0.48)
    }

    // MARK: - System assistance

    /// Opens the macOS System Settings pane where the user can download more voices.
    static func openVoiceDownloadSettings() {
        let urls = [
            "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?SpokenContent",
            "x-apple.systempreferences:com.apple.preference.speech"
        ]
        for candidate in urls {
            if let url = URL(string: candidate), NSWorkspace.shared.open(url) { return }
        }
    }
}

extension Speech: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.advanceQueue() }
    }
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
            self.nowSpeaking = ""
            self.pendingQueue.removeAll()
            self.queueRemaining = 0
        }
    }

    private func advanceQueue() {
        if pendingQueue.isEmpty {
            isSpeaking = false
            nowSpeaking = ""
            queueRemaining = 0
            return
        }
        let next = pendingQueue.removeFirst()
        queueRemaining = pendingQueue.count
        enqueue(next, rate: nil, clearFirst: false)
    }
}

extension AVSpeechSynthesisVoiceQuality {
    /// Ordering helper: default < enhanced < premium.
    var rank: Int {
        switch self {
        case .default:  return 0
        case .enhanced: return 1
        case .premium:  return 2
        @unknown default: return 0
        }
    }

    var label: String {
        switch self {
        case .default:  return "Standard"
        case .enhanced: return "Enhanced"
        case .premium:  return "Premium"
        @unknown default: return "Standard"
        }
    }
}
