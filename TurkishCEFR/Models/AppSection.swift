import SwiftUI

/// The top-level navigation target the user has chosen in the sidebar.
/// Lets us unify lessons, tools, and progress views under a single sidebar
/// selection rather than having a handful of disconnected sheet presenters.
enum AppSection: Hashable {
    case welcome
    case level(CEFRLevel)
    case lesson(lessonID: String)
    case tool(Tool)
    case progress(ProgressTab)
    case podcasts

    enum Tool: String, CaseIterable, Identifiable, Hashable {
        case dictionary, conjugator, review, daily, phrasebook
        case dictation, gloss, pronunciation, journal, recap
        // Two new lab-style tools added to cover phonology (vowel
        // harmony) and active output (shadow speaking). They sit in
        // their own sidebar group so beginners can find them easily.
        case harmony, shadow

        var id: String { rawValue }

        var title: String {
            switch self {
            case .dictionary:    return "Sözlük · Dictionary"
            case .conjugator:    return "Fiil · Conjugator"
            case .review:        return "Tekrar · SRS Review"
            case .daily:         return "Günün Görevi · Daily"
            case .phrasebook:    return "Diyaloglar · Phrasebook"
            case .dictation:     return "Dikte · Dictation"
            case .gloss:         return "Satır Arası · Gloss"
            case .pronunciation: return "Telaffuz · Coach"
            case .journal:       return "Günlük · Journal"
            case .recap:         return "Haftalık · Recap"
            case .harmony:       return "Ünlü Uyumu · Vowel Harmony Lab"
            case .shadow:        return "Gölge Konuşma · Shadow Room"
            }
        }

        var systemImage: String {
            switch self {
            case .dictionary:    return "character.book.closed.fill"
            case .conjugator:    return "function"
            case .review:        return "arrow.triangle.2.circlepath"
            case .daily:         return "sun.max.fill"
            case .phrasebook:    return "text.bubble.fill"
            case .dictation:     return "ear.and.waveform"
            case .gloss:         return "text.alignleft"
            case .pronunciation: return "mic.fill"
            case .journal:       return "book.closed.fill"
            case .recap:         return "calendar.badge.clock"
            case .harmony:       return "circle.hexagongrid.fill"
            case .shadow:        return "waveform.and.mic"
            }
        }

        var tint: Color {
            switch self {
            case .dictionary:    return .indigo
            case .conjugator:    return .purple
            case .review:        return .teal
            case .daily:         return .orange
            case .phrasebook:    return .pink
            case .dictation:     return .cyan
            case .gloss:         return .mint
            case .pronunciation: return .red
            case .journal:       return .brown
            case .recap:         return .yellow
            case .harmony:       return .green
            case .shadow:        return .blue
            }
        }

        /// Classic set of original tools that existed before the Beginner-
        /// first refactor. Used by the sidebar to render two visually-
        /// distinct groups ("Toolkit" + "Practice").
        static var classicTools: [Tool] {
            [.dictionary, .conjugator, .review, .daily, .phrasebook]
        }

        /// Post-refactor practice tools that focus on active output
        /// (dictation, pronunciation, gloss) and reflection (journal, recap).
        static var practiceTools: [Tool] {
            [.dictation, .pronunciation, .gloss, .journal, .recap]
        }

        /// Phonology + shadowing "lab" tools — more immersive than the
        /// quick reference toolkit, more focused than the long review
        /// loop in practice tools.
        static var labTools: [Tool] {
            [.harmony, .shadow]
        }
    }

    enum ProgressTab: String, CaseIterable, Identifiable, Hashable {
        case stats, heatmap, badges

        var id: String { rawValue }

        var title: String {
            switch self {
            case .stats:   return "İstatistikler · Dashboard"
            case .heatmap: return "Aktivite · Heatmap"
            case .badges:  return "Rozetler · Badges"
            }
        }

        var systemImage: String {
            switch self {
            case .stats:   return "chart.bar.xaxis.ascending"
            case .heatmap: return "square.grid.4x3.fill"
            case .badges:  return "rosette"
            }
        }

        var tint: Color {
            switch self {
            case .stats:   return .blue
            case .heatmap: return .green
            case .badges:  return .yellow
            }
        }
    }
}
