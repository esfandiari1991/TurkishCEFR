import Foundation
import Combine

/// Auto-generated journal entry for every day the learner uses the app.
/// Entries are additive — when `log(...)` is called multiple times within
/// one calendar day they coalesce into a single row rather than creating
/// separate rows.
///
/// Why a journal? Two reasons:
///  1. Self-efficacy. Language research (Dörnyei 2001, Oxford 2017) shows
///     visible proof of daily effort is the single strongest predictor
///     of whether a self-study learner keeps showing up.
///  2. Recall. A free-text note field lets the learner jot down "today
///     I finally understood -DIK" or "struggling with vowel harmony in
///     -mak" and re-read it a week later.
///
/// Storage: JSON file in Application Support. Simple array of entries —
/// at one row per day we max out at ~365 rows per year of heavy usage,
/// so no need for a proper database.
@MainActor
final class StudyJournalStore: ObservableObject {
    static let shared = StudyJournalStore()

    struct Entry: Codable, Identifiable, Hashable {
        var id: String { dayKey }            // yyyy-MM-dd
        var dayKey: String
        var lessonIDs: Set<String> = []
        var lessonTitles: [String] = []
        var wordsMastered: [String] = []
        var grammarStudied: [String] = []
        var xpEarned: Int = 0
        var minutesStudied: Int = 0
        var note: String = ""
        var updatedAt: Date = .init()

        var date: Date {
            ISO8601DateFormatter.dayKeyFormatter.date(from: dayKey) ?? .init()
        }
    }

    @Published private(set) var entries: [Entry] = []

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory,
                                           in: .userDomainMask).first!
            .appendingPathComponent("TurkishCEFR", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir,
                                                 withIntermediateDirectories: true)
        return dir.appendingPathComponent("journal.json")
    }()

    private init() { load() }

    // MARK: - Read

    var sortedEntries: [Entry] {
        entries.sorted { $0.dayKey > $1.dayKey }
    }

    func entry(for date: Date) -> Entry? {
        let key = ActivityDateKey.key(for: date)
        return entries.first { $0.dayKey == key }
    }

    // MARK: - Write

    /// Record that the learner did something today. Call sites fire-and-forget.
    func log(lessonID: String? = nil,
             lessonTitle: String? = nil,
             wordMastered: String? = nil,
             grammarTopic: String? = nil,
             xpEarned: Int = 0,
             minutesStudied: Int = 0) {
        let key = ActivityDateKey.key()
        var e = entries.first(where: { $0.dayKey == key }) ?? Entry(dayKey: key)

        if let lessonID { e.lessonIDs.insert(lessonID) }
        if let lessonTitle, !e.lessonTitles.contains(lessonTitle) {
            e.lessonTitles.append(lessonTitle)
        }
        if let w = wordMastered, !e.wordsMastered.contains(w) {
            e.wordsMastered.append(w)
        }
        if let g = grammarTopic, !e.grammarStudied.contains(g) {
            e.grammarStudied.append(g)
        }
        e.xpEarned += max(0, xpEarned)
        e.minutesStudied += max(0, minutesStudied)
        e.updatedAt = .init()

        if let idx = entries.firstIndex(where: { $0.dayKey == key }) {
            entries[idx] = e
        } else {
            entries.append(e)
        }
        save()
    }

    func setNote(_ text: String, for date: Date = .init()) {
        let key = ActivityDateKey.key(for: date)
        if let idx = entries.firstIndex(where: { $0.dayKey == key }) {
            entries[idx].note = text
            entries[idx].updatedAt = .init()
        } else {
            entries.append(.init(dayKey: key, note: text))
        }
        save()
    }

    // MARK: - Export

    /// Serialise every entry to pretty JSON for Export in Settings.
    func exportData() -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(sortedEntries)
    }

    // MARK: - Persistence

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Entry].self, from: data) else { return }
        entries = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}

extension ISO8601DateFormatter {
    static let dayKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
