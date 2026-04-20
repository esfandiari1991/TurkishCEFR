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

        var id: String { rawValue }

        var title: String {
            switch self {
            case .dictionary: return "Sözlük · Dictionary"
            case .conjugator: return "Fiil · Conjugator"
            case .review:     return "Tekrar · SRS Review"
            case .daily:      return "Günün Görevi · Daily"
            case .phrasebook: return "Diyaloglar · Phrasebook"
            }
        }

        var systemImage: String {
            switch self {
            case .dictionary: return "character.book.closed.fill"
            case .conjugator: return "function"
            case .review:     return "arrow.triangle.2.circlepath"
            case .daily:      return "sun.max.fill"
            case .phrasebook: return "text.bubble.fill"
            }
        }

        var tint: Color {
            switch self {
            case .dictionary: return .indigo
            case .conjugator: return .purple
            case .review:     return .teal
            case .daily:      return .orange
            case .phrasebook: return .pink
            }
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
