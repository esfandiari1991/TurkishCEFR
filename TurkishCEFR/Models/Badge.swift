import SwiftUI

struct Badge: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let tint: BadgeTint
    let xpReward: Int

    enum BadgeTint: String, Codable, Hashable {
        case crimson, gold, orchid, teal, mint, sky, amber, rose, indigo, silver

        var color: Color {
            switch self {
            case .crimson: return Color(red: 0.86, green: 0.22, blue: 0.34)
            case .gold:    return Color(red: 0.98, green: 0.78, blue: 0.20)
            case .orchid:  return Color(red: 0.70, green: 0.30, blue: 0.78)
            case .teal:    return Color(red: 0.20, green: 0.68, blue: 0.66)
            case .mint:    return Color(red: 0.36, green: 0.80, blue: 0.56)
            case .sky:     return Color(red: 0.28, green: 0.66, blue: 0.92)
            case .amber:   return Color(red: 0.98, green: 0.60, blue: 0.18)
            case .rose:    return Color(red: 0.98, green: 0.42, blue: 0.56)
            case .indigo:  return Color(red: 0.36, green: 0.38, blue: 0.78)
            case .silver:  return Color(red: 0.72, green: 0.74, blue: 0.80)
            }
        }
    }
}

enum BadgeCatalog {
    static let all: [Badge] = [
        Badge(id: "first-lesson",
              title: "İlk Adım",
              subtitle: "Complete your first lesson",
              systemImage: "flag.checkered",
              tint: .amber, xpReward: 20),
        Badge(id: "lessons-5",
              title: "Çalışkan",
              subtitle: "Complete 5 lessons",
              systemImage: "book.closed.fill",
              tint: .teal, xpReward: 30),
        Badge(id: "lessons-15",
              title: "Öğrenci",
              subtitle: "Complete 15 lessons",
              systemImage: "books.vertical.fill",
              tint: .indigo, xpReward: 60),
        Badge(id: "lessons-30",
              title: "Akademisyen",
              subtitle: "Complete 30 lessons",
              systemImage: "graduationcap.fill",
              tint: .orchid, xpReward: 120),
        Badge(id: "streak-3",
              title: "Üç Gün",
              subtitle: "Study 3 days in a row",
              systemImage: "flame.fill",
              tint: .amber, xpReward: 25),
        Badge(id: "streak-7",
              title: "Yedi Gün",
              subtitle: "Study 7 days in a row",
              systemImage: "flame.fill",
              tint: .crimson, xpReward: 60),
        Badge(id: "streak-30",
              title: "Otuz Gün",
              subtitle: "Study 30 days in a row",
              systemImage: "flame.fill",
              tint: .orchid, xpReward: 200),
        Badge(id: "words-25",
              title: "Kelime Avcısı",
              subtitle: "Master 25 words",
              systemImage: "character.book.closed.fill",
              tint: .mint, xpReward: 30),
        Badge(id: "words-100",
              title: "Sözlük",
              subtitle: "Master 100 words",
              systemImage: "text.book.closed.fill",
              tint: .sky, xpReward: 80),
        Badge(id: "words-250",
              title: "Polyglot",
              subtitle: "Master 250 words",
              systemImage: "globe",
              tint: .orchid, xpReward: 200),
        Badge(id: "perfectionist-10",
              title: "Kusursuz",
              subtitle: "10 perfect answers in a row",
              systemImage: "checkmark.seal.fill",
              tint: .gold, xpReward: 50),
        Badge(id: "level-a1",
              title: "A1 Tamamlandı",
              subtitle: "Finish every A1 lesson",
              systemImage: "a.square.fill",
              tint: .crimson, xpReward: 150),
        Badge(id: "level-a2",
              title: "A2 Tamamlandı",
              subtitle: "Finish every A2 lesson",
              systemImage: "a.square.fill",
              tint: .amber, xpReward: 150),
        Badge(id: "level-b1",
              title: "B1 Tamamlandı",
              subtitle: "Finish every B1 lesson",
              systemImage: "b.square.fill",
              tint: .mint, xpReward: 180),
        Badge(id: "level-b2",
              title: "B2 Tamamlandı",
              subtitle: "Finish every B2 lesson",
              systemImage: "b.square.fill",
              tint: .sky, xpReward: 180),
        Badge(id: "level-c1",
              title: "C1 Tamamlandı",
              subtitle: "Finish every C1 lesson",
              systemImage: "c.square.fill",
              tint: .indigo, xpReward: 220),
        Badge(id: "level-c2",
              title: "C2 Tamamlandı",
              subtitle: "Finish every C2 lesson",
              systemImage: "c.square.fill",
              tint: .orchid, xpReward: 300),
        Badge(id: "xp-500",
              title: "Yükseliş",
              subtitle: "Earn 500 XP",
              systemImage: "bolt.fill",
              tint: .gold, xpReward: 0),
        Badge(id: "xp-2000",
              title: "Uzman",
              subtitle: "Earn 2 000 XP",
              systemImage: "bolt.circle.fill",
              tint: .crimson, xpReward: 0),
        Badge(id: "category-vocab",
              title: "Kelime Şampiyonu",
              subtitle: "Clear a lesson's vocabulary",
              systemImage: "character.book.closed",
              tint: .teal, xpReward: 15),
        Badge(id: "category-grammar",
              title: "Dilbilgisi Ustası",
              subtitle: "Study all of a lesson's grammar",
              systemImage: "text.alignleft",
              tint: .indigo, xpReward: 15),
        Badge(id: "category-phrases",
              title: "Cümle Kralı",
              subtitle: "Read all of a lesson's phrases",
              systemImage: "bubble.left.and.bubble.right.fill",
              tint: .rose, xpReward: 15),
        Badge(id: "category-exercises",
              title: "Alıştırma Ustası",
              subtitle: "Clear a lesson's exercises",
              systemImage: "checklist",
              tint: .mint, xpReward: 15)
    ]

    static let byID: [String: Badge] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
}
