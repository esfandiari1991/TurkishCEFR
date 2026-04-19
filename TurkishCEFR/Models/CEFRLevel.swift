import SwiftUI

enum CEFRLevel: String, CaseIterable, Identifiable, Codable, Hashable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    case c2 = "C2"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .a1: return "Başlangıç"
        case .a2: return "Temel"
        case .b1: return "Orta"
        case .b2: return "İyi"
        case .c1: return "İleri"
        case .c2: return "Üstat"
        }
    }

    var englishTitle: String {
        switch self {
        case .a1: return "Beginner"
        case .a2: return "Elementary"
        case .b1: return "Intermediate"
        case .b2: return "Upper-Intermediate"
        case .c1: return "Advanced"
        case .c2: return "Mastery"
        }
    }

    var summary: String {
        switch self {
        case .a1: return "Understand and use familiar everyday expressions and basic phrases."
        case .a2: return "Communicate in simple, routine tasks on familiar topics."
        case .b1: return "Deal with most situations while traveling in Turkish-speaking areas."
        case .b2: return "Interact fluently and spontaneously with native speakers."
        case .c1: return "Express ideas fluently and use language effectively for academic purposes."
        case .c2: return "Understand virtually everything and express yourself precisely."
        }
    }

    var accentColor: Color {
        switch self {
        case .a1: return Color(red: 0.98, green: 0.50, blue: 0.45) // coral
        case .a2: return Color(red: 0.96, green: 0.70, blue: 0.30) // amber
        case .b1: return Color(red: 0.42, green: 0.78, blue: 0.52) // green
        case .b2: return Color(red: 0.30, green: 0.66, blue: 0.88) // sky
        case .c1: return Color(red: 0.55, green: 0.48, blue: 0.92) // violet
        case .c2: return Color(red: 0.82, green: 0.32, blue: 0.68) // magenta
        }
    }

    var gradient: LinearGradient {
        LinearGradient(
            colors: [accentColor.opacity(0.85), accentColor.opacity(0.55)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var systemImage: String {
        switch self {
        case .a1: return "leaf.fill"
        case .a2: return "sparkles"
        case .b1: return "flame.fill"
        case .b2: return "bolt.fill"
        case .c1: return "star.fill"
        case .c2: return "crown.fill"
        }
    }
}
