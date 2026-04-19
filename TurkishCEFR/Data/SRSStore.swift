import Foundation
import Combine

/// Simple spaced-repetition deck using a reduced SM-2 algorithm. Cards are
/// auto-harvested from the daily corpus and from every lesson's vocabulary as
/// soon as the learner marks the lesson complete.
final class SRSStore: ObservableObject {
    static let shared = SRSStore()

    struct Card: Codable, Hashable, Identifiable {
        var id: String          // tr
        var front: String       // Turkish
        var back:  String       // English
        var ease:  Double = 2.5 // SM-2 E-factor
        var interval: Int = 0   // days
        var repetitions: Int = 0
        var dueDate: Date = .init()
        var lapses: Int = 0
        var origin: String = "lesson"
    }

    @Published private(set) var cards: [Card] = []

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory,
                                           in: .userDomainMask).first!
            .appendingPathComponent("TurkishCEFR", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir,
                                                 withIntermediateDirectories: true)
        return dir.appendingPathComponent("srs.json")
    }()

    private init() { load() }

    // MARK: - Queue

    var dueCards: [Card] {
        let now = Date()
        return cards.filter { $0.dueDate <= now }
                    .sorted { $0.dueDate < $1.dueDate }
    }

    var dueCount: Int { dueCards.count }

    // MARK: - Actions

    enum Grade: Int { case again = 0, hard = 1, good = 2, easy = 3 }

    @discardableResult
    func enroll(front: String, back: String, origin: String) -> Bool {
        let id = front.lowercased(with: Locale(identifier: "tr_TR"))
        guard !cards.contains(where: { $0.id == id }) else { return false }
        cards.append(Card(id: id, front: front, back: back, origin: origin))
        save()
        return true
    }

    func grade(_ id: String, _ grade: Grade) {
        guard let idx = cards.firstIndex(where: { $0.id == id }) else { return }
        var c = cards[idx]
        switch grade {
        case .again:
            c.repetitions = 0
            c.interval = 1
            c.lapses += 1
            c.ease = max(1.3, c.ease - 0.2)
        case .hard:
            c.interval = c.repetitions == 0 ? 1 : max(1, Int(Double(c.interval) * 1.2))
            c.repetitions += 1
            c.ease = max(1.3, c.ease - 0.15)
        case .good:
            c.repetitions += 1
            switch c.repetitions {
            case 1: c.interval = 1
            case 2: c.interval = 6
            default: c.interval = Int(Double(c.interval) * c.ease)
            }
        case .easy:
            c.repetitions += 1
            c.interval = max(4, Int(Double(c.interval == 0 ? 4 : c.interval) * c.ease * 1.3))
            c.ease += 0.1
        }
        c.dueDate = Calendar.current.date(byAdding: .day,
                                          value: max(1, c.interval),
                                          to: Calendar.current.startOfDay(for: .init())) ?? .init()
        cards[idx] = c
        save()
    }

    func resetAll() {
        cards.removeAll()
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Card].self, from: data) else { return }
        cards = decoded
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            // Non-fatal; progress rebuilds from lesson completion on next launch.
        }
    }
}
