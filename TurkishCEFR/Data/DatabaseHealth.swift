import Foundation
import Combine

/// Runs a set of cheap sanity checks across every backing store at launch
/// and exposes the result to a user-visible "Integrity" panel in Settings.
///
/// Why: early testers reported the classic "blank screen" bug — corpus
/// hadn't finished loading so some views showed a spinner forever. A
/// self-diagnosing health report means the user can open Settings → Data
/// → Integrity, see every store's status at a glance, and hit a single
/// Repair button if anything is off. No one should ever have to delete
/// preferences files by hand.
///
/// Checks are intentionally synchronous and O(n) over pre-loaded arrays
/// — they must not trigger any lazy work.
@MainActor
final class DatabaseHealth: ObservableObject {
    static let shared = DatabaseHealth()

    enum Status: String, Codable {
        case healthy, warning, broken, pending
    }

    struct Report: Identifiable, Hashable {
        let id = UUID()
        let store: String
        let status: Status
        let message: String
        let count: Int
        let threshold: Int
    }

    @Published private(set) var reports: [Report] = []
    @Published private(set) var lastCheckedAt: Date? = nil

    /// Runs every check. Safe to call from any thread — hops to main.
    func runAll(curriculum: CurriculumStore) async {
        var collected: [Report] = []
        collected.append(checkCurriculum(curriculum))
        collected.append(checkCorpus())
        collected.append(checkSRS())
        collected.append(checkProgress())
        collected.append(checkSettings())
        collected.append(checkLinkCache())

        await MainActor.run {
            self.reports = collected
            self.lastCheckedAt = Date()
        }
    }

    var overall: Status {
        if reports.contains(where: { $0.status == .broken }) { return .broken }
        if reports.contains(where: { $0.status == .warning }) { return .warning }
        if reports.isEmpty { return .pending }
        return .healthy
    }

    // MARK: - Per-store checks

    private func checkCurriculum(_ store: CurriculumStore) -> Report {
        let all = store.allLessons
        if all.isEmpty {
            return .init(store: "Curriculum",
                         status: .broken,
                         message: "No lessons found for any level. Re-install the app from the official installer.",
                         count: 0, threshold: 60)
        }
        let perLevel = CEFRLevel.allCases.map { store.lessons(for: $0).count }
        let minPerLevel = perLevel.min() ?? 0
        if minPerLevel < 1 {
            return .init(store: "Curriculum",
                         status: .warning,
                         message: "One or more levels has no lessons — some tabs will look empty.",
                         count: all.count, threshold: 6)
        }
        return .init(store: "Curriculum",
                     status: .healthy,
                     message: "\(all.count) lessons across \(CEFRLevel.allCases.count) levels.",
                     count: all.count, threshold: 60)
    }

    private func checkCorpus() -> Report {
        let sentenceCount = CorpusStore.shared.sentenceCount
        let wordCount = CorpusStore.shared.wordCount
        if sentenceCount == 0 && wordCount == 0 {
            return .init(store: "Offline corpus",
                         status: .warning,
                         message: "No sentences/words loaded yet. The corpus will load in the background the first time you open Dictionary or Daily Challenge.",
                         count: 0, threshold: 1000)
        }
        if sentenceCount < 500 {
            return .init(store: "Offline corpus",
                         status: .warning,
                         message: "Corpus has only \(sentenceCount) sentences — below the 500 recommended. Some features may be sparse.",
                         count: sentenceCount, threshold: 500)
        }
        return .init(store: "Offline corpus",
                     status: .healthy,
                     message: "\(sentenceCount) sentences · \(wordCount) word entries loaded.",
                     count: sentenceCount + wordCount, threshold: 1000)
    }

    private func checkSRS() -> Report {
        let cards = SRSStore.shared.cards
        return .init(store: "Spaced-repetition deck",
                     status: .healthy,
                     message: cards.isEmpty
                        ? "No cards yet. Master words in a lesson to enroll them here automatically."
                        : "\(cards.count) cards enrolled.",
                     count: cards.count, threshold: 0)
    }

    private func checkProgress() -> Report {
        let xp = UserDefaults.standard.integer(forKey: "TurkishCEFR.progress.v2.xp")
        let hasKey = UserDefaults.standard.object(forKey: "TurkishCEFR.progress.v2") != nil
        if !hasKey {
            return .init(store: "Player progress",
                         status: .healthy,
                         message: "No progress yet — you're a brand-new learner. Welcome!",
                         count: 0, threshold: 0)
        }
        return .init(store: "Player progress",
                     status: .healthy,
                     message: "Progress snapshot loaded (XP ≈ \(xp)).",
                     count: xp, threshold: 0)
    }

    private func checkSettings() -> Report {
        // Sanity-check user preferences don't have impossible values. We
        // only flag a range violation when the key has actually been
        // written by the Settings UI — `UserDefaults.double(forKey:)`
        // returns 0.0 for unset keys, which would otherwise silently
        // pass the bounds test. The valid range (0.3…0.7) mirrors the
        // slider in SettingsView so any value outside it indicates a
        // corrupted or hand-edited plist.
        let hasRate = UserDefaults.standard.object(forKey: "speechRate") != nil
        let rate = UserDefaults.standard.double(forKey: "speechRate")
        if hasRate && (rate < 0.3 || rate > 0.7) {
            return .init(store: "Settings",
                         status: .warning,
                         message: "Speech rate out of range (\(rate)). Reset to default to fix.",
                         count: 0, threshold: 0)
        }
        return .init(store: "Settings",
                     status: .healthy,
                     message: "All preferences valid.",
                     count: 0, threshold: 0)
    }

    private func checkLinkCache() -> Report {
        let records = LinkHealthChecker.shared.records.count
        let totalLinks = LessonResources.allReferences.count
        if totalLinks == 0 {
            return .init(store: "Watch & Learn links",
                         status: .warning,
                         message: "No curated YouTube videos bundled.",
                         count: 0, threshold: 10)
        }
        return .init(store: "Watch & Learn links",
                     status: .healthy,
                     message: "\(totalLinks) videos curated · \(records) health-check entries cached.",
                     count: totalLinks, threshold: 10)
    }
}
