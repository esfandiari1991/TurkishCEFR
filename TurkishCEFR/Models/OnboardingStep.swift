import SwiftUI

/// Individual screens of the first-launch tour. Each step is a full-screen
/// friendly card with an illustration, a short headline, a paragraph of
/// plain-English explanation, and — optionally — a concrete next action
/// (e.g. "Pick a voice", "Open A1 · Beginner"). No jargon, no shortcuts.
enum OnboardingStep: Int, CaseIterable, Identifiable {
    case welcome
    case howItWorks
    case cefrIntro
    case gamification
    case voice
    case tools
    case offline
    case help
    case ready

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .welcome:      return "Hoş geldin! 👋 Welcome"
        case .howItWorks:   return "How the app works"
        case .cefrIntro:    return "What does A1, B2, C1 mean?"
        case .gamification: return "Your streak, XP and badges"
        case .voice:        return "Hearing real Turkish"
        case .tools:        return "Tools to practise every day"
        case .offline:      return "Works fully offline"
        case .help:         return "Need help? Just look for ?"
        case .ready:        return "You're ready. Let's start!"
        }
    }

    var headline: String {
        switch self {
        case .welcome:
            return "TurkishCEFR is a complete Turkish course on your Mac. This quick tour takes less than a minute."
        case .howItWorks:
            return "Pick a level on the left, open a lesson, and tap the big blue Start button. Every lesson is Vocabulary → Grammar → Phrases → Exercises."
        case .cefrIntro:
            return "CEFR is an international way to measure language skill. A1 = complete beginner. C2 = fluent. Start at A1 — even if you think you know some words, it's good revision."
        case .gamification:
            return "Every action earns XP. Come back every day to keep your 🔥 streak alive. Badges unlock automatically — you don't need to hunt for them."
        case .voice:
            return "Every Turkish word and sentence is clickable — click it to hear it. By default we use the system voice. For the best Istanbul accent, download Yelda from System Settings (we'll show you how)."
        case .tools:
            return "In the Toolkit section on the left you'll find a Dictionary, Verb Conjugator, Daily Challenge, Spaced-Repetition Review, and a Phrasebook of real dialogues. Everything works offline."
        case .offline:
            return "No subscription, no login, no network required. Turn on Online mode in the top bar if you want richer dictionary lookups and AI explanations — but you never have to."
        case .help:
            return "Anywhere in the app, if you see a small ? icon, click it for a plain-English explanation. The keyboard legend (Help menu → Keyboard Legend) lists every shortcut — but you never need a shortcut to use the app."
        case .ready:
            return "That's it! You can re-open this tour anytime from Settings → Help → Restart Tour. Close this card and click \"A1 · Beginner\" in the sidebar to begin."
        }
    }

    var systemImage: String {
        switch self {
        case .welcome:      return "sparkles"
        case .howItWorks:   return "book.pages.fill"
        case .cefrIntro:    return "graduationcap.fill"
        case .gamification: return "flame.fill"
        case .voice:        return "waveform.circle.fill"
        case .tools:        return "hammer.fill"
        case .offline:      return "wifi.slash"
        case .help:         return "questionmark.circle.fill"
        case .ready:        return "checkmark.seal.fill"
        }
    }

    var primaryActionLabel: String {
        switch self {
        case .ready: return "Start learning"
        default:     return "Next"
        }
    }
}
