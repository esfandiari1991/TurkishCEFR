import SwiftUI

/// User-visible online/offline mode. This is the single switch the user
/// flips in Settings (or the header pill) to decide whether enrichment
/// calls should hit the network.
///
/// Offline guarantees the app works fully without internet — bundled
/// corpus + bundled dictionary snapshot + local conjugator + SRS.
/// Online unlocks richer lookups (TDK Sözlük HTTP, Wiktionary API) and
/// free AI providers (Groq, Gemini, HuggingFace, OpenRouter) for
/// explanations, translations and interlinear glosses.
enum NetworkMode: String, Codable, CaseIterable, Identifiable {
    case offline
    case online

    var id: String { rawValue }

    var title: String {
        switch self {
        case .offline: return "Offline"
        case .online:  return "Online"
        }
    }

    var systemImage: String {
        switch self {
        case .offline: return "externaldrive.fill"
        case .online:  return "antenna.radiowaves.left.and.right"
        }
    }

    var tint: Color {
        switch self {
        case .offline: return .blue
        case .online:  return .green
        }
    }

    var description: String {
        switch self {
        case .offline:
            return "Uses only the bundled corpus + dictionary. Guaranteed to work without internet."
        case .online:
            return "Adds online Turkish dictionaries (TDK, Wiktionary) + free AI providers (Groq / Gemini / HuggingFace) for richer explanations. Falls back to offline if unreachable."
        }
    }
}

/// User-tunable online mode and provider preferences. Empty API keys just
/// disable that provider — we never block the app on missing credentials.
final class NetworkModeStore: ObservableObject {
    static let shared = NetworkModeStore()

    @AppStorage("TurkishCEFR.network.mode") private var rawMode: String = NetworkMode.offline.rawValue

    /// Free-to-use providers the user may enable. Each key is optional —
    /// if it's empty we skip that provider gracefully.
    @AppStorage("TurkishCEFR.ai.groqKey")    var groqKey: String = ""
    @AppStorage("TurkishCEFR.ai.geminiKey")  var geminiKey: String = ""
    @AppStorage("TurkishCEFR.ai.hfKey")      var hfKey: String = ""
    @AppStorage("TurkishCEFR.ai.openRouterKey") var openRouterKey: String = ""

    @AppStorage("TurkishCEFR.network.preferredProvider") var preferredProvider: String = "groq"

    var mode: NetworkMode {
        get { NetworkMode(rawValue: rawMode) ?? .offline }
        set { rawMode = newValue.rawValue; objectWillChange.send() }
    }

    /// True if we should attempt any online enrichment right now.
    var isOnline: Bool { mode == .online }

    /// True if at least one AI provider has a key configured.
    var hasAnyAIKey: Bool {
        !groqKey.isEmpty || !geminiKey.isEmpty || !hfKey.isEmpty || !openRouterKey.isEmpty
    }

    func toggle() {
        mode = (mode == .offline) ? .online : .offline
    }
}
