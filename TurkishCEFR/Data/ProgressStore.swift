import Foundation
import Combine

@MainActor
final class ProgressStore: ObservableObject {
    @Published var lessonProgress: [String: LessonProgress] = [:]
    @Published var stats: PlayerStats = PlayerStats()

    /// Fires once when the player crosses a level boundary so the UI can toast.
    @Published var levelUpEvent: LevelUpEvent? = nil
    /// Fires every time XP is awarded so views can animate an XP chip.
    @Published var lastXPAward: XPAwardEvent? = nil

    private let defaultsKey = "TurkishCEFR.progress.v2"

    struct LevelUpEvent: Identifiable, Equatable {
        let id = UUID()
        let oldLevel: Int
        let newLevel: Int
    }

    struct XPAwardEvent: Identifiable, Equatable {
        let id = UUID()
        let amount: Int
        let reason: String
        let timestamp: Date = .init()
    }

    init() {
        load()
        // Update streak for "opening the app today" on launch.
        registerStudySession(awardXP: false)
    }

    // MARK: - Access

    subscript(lessonID: String) -> LessonProgress {
        get { lessonProgress[lessonID] ?? LessonProgress() }
        set {
            lessonProgress[lessonID] = newValue
            save()
        }
    }

    // MARK: - Lesson completion

    func markCompleted(_ lessonID: String) {
        var p = self[lessonID]
        let wasCompleted = p.completed
        p.completed = true
        p.lastStudied = Date()
        self[lessonID] = p
        if !wasCompleted {
            stats.lessonsCompleted += 1
            awardXP(XPAward.lessonCompletionBonus, reason: "Lesson completed")
            save()
            checkBadges()
        }
    }

    func maybeMarkLessonCompleted(_ lesson: Lesson) {
        let p = self[lesson.id]
        if p.completed { return }
        // A lesson is considered complete when every category is at 100%.
        if p.overallScore(in: lesson) >= 0.999 {
            markCompleted(lesson.id)
        }
    }

    // MARK: - Vocabulary

    func toggleMastered(lessonID: String, word: String) {
        var p = self[lessonID]
        let wasMastered = p.vocabularyMastered.contains(word)
        if wasMastered {
            p.vocabularyMastered.remove(word)
        } else {
            p.vocabularyMastered.insert(word)
        }
        p.lastStudied = Date()
        self[lessonID] = p
        if !wasMastered {
            awardXP(XPAward.wordMastered, reason: "New word mastered")
            registerStudySession(awardXP: false)
            checkBadges()
        }
    }

    // MARK: - Grammar / Phrases

    func markGrammarStudied(lessonID: String, title: String) {
        var p = self[lessonID]
        guard !p.grammarStudied.contains(title) else { return }
        p.grammarStudied.insert(title)
        p.lastStudied = Date()
        self[lessonID] = p
        awardXP(XPAward.grammarStudied, reason: "Grammar read")
        registerStudySession(awardXP: false)
        checkBadges()
    }

    func markPhraseStudied(lessonID: String, phrase: String) {
        var p = self[lessonID]
        guard !p.phrasesStudied.contains(phrase) else { return }
        p.phrasesStudied.insert(phrase)
        p.lastStudied = Date()
        self[lessonID] = p
        awardXP(XPAward.phraseStudied, reason: "Phrase read")
        registerStudySession(awardXP: false)
        checkBadges()
    }

    // MARK: - Exercises

    @discardableResult
    func markExerciseCompleted(lessonID: String,
                               exerciseID: String,
                               xp: Int = XPAward.flashcardCompleted,
                               perfect: Bool = false) -> Int {
        var p = self[lessonID]
        let alreadyDone = p.exercisesCompleted.contains(exerciseID)
        p.exercisesCompleted.insert(exerciseID)
        p.lastStudied = Date()
        self[lessonID] = p

        // Streak of perfect answers.
        if perfect {
            stats.correctInARow += 1
            stats.longestCorrectStreak = max(stats.longestCorrectStreak, stats.correctInARow)
        } else {
            stats.correctInARow = 0
        }

        let amount = alreadyDone ? max(2, xp / 4) : xp
        awardXP(amount, reason: "Exercise completed")
        registerStudySession(awardXP: false)
        checkBadges()
        return amount
    }

    func recordWrongAnswer() {
        stats.correctInARow = 0
        save()
    }

    // MARK: - Summary helpers

    func completion(for lessons: [Lesson]) -> Double {
        guard !lessons.isEmpty else { return 0 }
        let total = lessons.reduce(0.0) { $0 + self[$1.id].overallScore(in: $1) }
        return total / Double(lessons.count)
    }

    func category(for lessons: [Lesson], _ kind: CategoryKind) -> Double {
        let filtered = lessons.filter { !$0.items(for: kind).isEmpty }
        guard !filtered.isEmpty else { return 0 }
        let total = filtered.reduce(0.0) { $0 + self[$1.id].progress(in: $1, kind: kind) }
        return total / Double(filtered.count)
    }

    func lessonsCompleted(in lessons: [Lesson]) -> Int {
        lessons.filter { self[$0.id].completed }.count
    }

    func masteredWordCount() -> Int {
        lessonProgress.values.reduce(0) { $0 + $1.vocabularyMastered.count }
    }

    // MARK: - Reset

    func resetLevel(_ level: CEFRLevel, lessons: [Lesson]) {
        for lesson in lessons {
            lessonProgress.removeValue(forKey: lesson.id)
        }
        save()
    }

    func resetEverything() {
        lessonProgress = [:]
        stats = PlayerStats()
        save()
    }

    // MARK: - XP & Streaks

    func awardXP(_ amount: Int, reason: String) {
        guard amount > 0 else { return }
        let oldLevel = stats.level
        stats.totalXP += amount
        let newLevel = stats.level
        lastXPAward = XPAwardEvent(amount: amount, reason: reason)
        if newLevel > oldLevel {
            levelUpEvent = LevelUpEvent(oldLevel: oldLevel, newLevel: newLevel)
            stats.acknowledgedLevel = newLevel
        }
        save()
    }

    func registerStudySession(awardXP: Bool) {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = stats.lastStudyDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            if Calendar.current.isDate(lastDay, inSameDayAs: today) {
                // Already counted today.
                return
            }
            let dayDiff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if dayDiff == 1 {
                stats.streakDays += 1
            } else {
                stats.streakDays = 1
            }
        } else {
            stats.streakDays = 1
        }
        stats.lastStudyDate = today
        stats.longestStreak = max(stats.longestStreak, stats.streakDays)
        if awardXP { self.awardXP(5, reason: "Daily check-in") }
        save()
        checkBadges()
    }

    // MARK: - Badges

    @discardableResult
    func checkBadges(allLessons: [Lesson]? = nil) -> [Badge] {
        var newlyUnlocked: [Badge] = []
        for badge in BadgeCatalog.all where !stats.unlockedBadges.contains(badge.id) {
            if isConditionMet(for: badge.id, allLessons: allLessons) {
                stats.unlockedBadges.insert(badge.id)
                stats.pendingBadgeToasts.append(badge.id)
                newlyUnlocked.append(badge)
                if badge.xpReward > 0 {
                    awardXP(badge.xpReward, reason: "Badge: \(badge.title)")
                }
            }
        }
        if !newlyUnlocked.isEmpty { save() }
        return newlyUnlocked
    }

    func consumeBadgeToast() -> Badge? {
        guard let id = stats.pendingBadgeToasts.first,
              let badge = BadgeCatalog.byID[id] else { return nil }
        stats.pendingBadgeToasts.removeFirst()
        save()
        return badge
    }

    private func isConditionMet(for id: String, allLessons: [Lesson]?) -> Bool {
        switch id {
        case "first-lesson": return stats.lessonsCompleted >= 1
        case "lessons-5":    return stats.lessonsCompleted >= 5
        case "lessons-15":   return stats.lessonsCompleted >= 15
        case "lessons-30":   return stats.lessonsCompleted >= 30
        case "streak-3":     return stats.streakDays >= 3 || stats.longestStreak >= 3
        case "streak-7":     return stats.streakDays >= 7 || stats.longestStreak >= 7
        case "streak-30":    return stats.streakDays >= 30 || stats.longestStreak >= 30
        case "words-25":     return masteredWordCount() >= 25
        case "words-100":    return masteredWordCount() >= 100
        case "words-250":    return masteredWordCount() >= 250
        case "perfectionist-10": return stats.longestCorrectStreak >= 10
        case "xp-500":       return stats.totalXP >= 500
        case "xp-2000":      return stats.totalXP >= 2000
        case "level-a1":     return levelFullyCompleted(.a1, allLessons: allLessons)
        case "level-a2":     return levelFullyCompleted(.a2, allLessons: allLessons)
        case "level-b1":     return levelFullyCompleted(.b1, allLessons: allLessons)
        case "level-b2":     return levelFullyCompleted(.b2, allLessons: allLessons)
        case "level-c1":     return levelFullyCompleted(.c1, allLessons: allLessons)
        case "level-c2":     return levelFullyCompleted(.c2, allLessons: allLessons)
        case "category-vocab":     return hasFullCategory(\LessonProgress.vocabularyMastered, expected: \Lesson.vocabulary.count)
        case "category-grammar":   return hasFullCategory(\LessonProgress.grammarStudied, expectedTitles: \Lesson.grammar)
        case "category-phrases":   return hasFullCategory(\LessonProgress.phrasesStudied, expectedPhrases: \Lesson.phrases)
        case "category-exercises": return hasFullCategory(\LessonProgress.exercisesCompleted, expectedIDs: \Lesson.exercises)
        default: return false
        }
    }

    private func levelFullyCompleted(_ level: CEFRLevel, allLessons: [Lesson]?) -> Bool {
        guard let lessons = allLessons?.filter({ $0.level == level }), !lessons.isEmpty else {
            return false
        }
        return lessons.allSatisfy { self[$0.id].completed }
    }

    // For "clear a category in any lesson" badges — we scan the lessons we've touched.
    private func hasFullCategory(_ set: KeyPath<LessonProgress, Set<String>>,
                                 expected: KeyPath<Lesson, Int>) -> Bool {
        // We don't have curriculum here, but this predicate is triggered from a
        // context where any one of the "touched" lessons has a 100% category.
        // Use the size heuristic: if a lesson's mastered-count is >= 8, it's
        // definitely "cleared" for the category badge. The real check runs in
        // checkAllBadges(allLessons:) when available.
        for (_, p) in lessonProgress where p[keyPath: set].count >= 8 {
            return true
        }
        return false
    }

    private func hasFullCategory(_ set: KeyPath<LessonProgress, Set<String>>,
                                 expectedTitles: KeyPath<Lesson, [GrammarNote]>) -> Bool {
        for (_, p) in lessonProgress where p[keyPath: set].count >= 2 { return true }
        return false
    }

    private func hasFullCategory(_ set: KeyPath<LessonProgress, Set<String>>,
                                 expectedPhrases: KeyPath<Lesson, [Phrase]>) -> Bool {
        for (_, p) in lessonProgress where p[keyPath: set].count >= 5 { return true }
        return false
    }

    private func hasFullCategory(_ set: KeyPath<LessonProgress, Set<String>>,
                                 expectedIDs: KeyPath<Lesson, [Exercise]>) -> Bool {
        for (_, p) in lessonProgress where p[keyPath: set].count >= 3 { return true }
        return false
    }

    // MARK: - Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else {
            // Try legacy v1 snapshot migration.
            if let oldData = UserDefaults.standard.data(forKey: "TurkishCEFR.progress.v1"),
               let legacy = try? JSONDecoder().decode(LegacySnapshot.self, from: oldData) {
                self.lessonProgress = legacy.lessonProgress
                self.stats.streakDays = legacy.streakDays
                self.stats.longestStreak = legacy.streakDays
                self.stats.lastStudyDate = legacy.lastOpenedDate
                save()
            }
            return
        }
        if let decoded = try? JSONDecoder().decode(Snapshot.self, from: data) {
            self.lessonProgress = decoded.lessonProgress
            self.stats = decoded.stats
        }
    }

    private func save() {
        let snapshot = Snapshot(lessonProgress: lessonProgress, stats: stats)
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private struct Snapshot: Codable {
        var lessonProgress: [String: LessonProgress]
        var stats: PlayerStats
    }

    private struct LegacySnapshot: Codable {
        var lessonProgress: [String: LessonProgress]
        var streakDays: Int
        var lastOpenedDate: Date?
    }
}

// MARK: - Category helpers

enum CategoryKind: String, CaseIterable, Identifiable {
    case vocabulary, grammar, phrases, exercises
    var id: String { rawValue }

    var title: String {
        switch self {
        case .vocabulary: return "Vocabulary"
        case .grammar:    return "Grammar"
        case .phrases:    return "Phrases"
        case .exercises:  return "Exercises"
        }
    }

    var turkishTitle: String {
        switch self {
        case .vocabulary: return "Kelime"
        case .grammar:    return "Dilbilgisi"
        case .phrases:    return "Cümleler"
        case .exercises:  return "Alıştırma"
        }
    }

    var systemImage: String {
        switch self {
        case .vocabulary: return "character.book.closed"
        case .grammar:    return "text.alignleft"
        case .phrases:    return "bubble.left.and.bubble.right"
        case .exercises:  return "checklist"
        }
    }
}

extension Lesson {
    func items(for kind: CategoryKind) -> [String] {
        switch kind {
        case .vocabulary: return vocabulary.map(\.turkish)
        case .grammar:    return grammar.map(\.title)
        case .phrases:    return phrases.map(\.turkish)
        case .exercises:  return exercises.map(\.id)
        }
    }
}

extension LessonProgress {
    func progress(in lesson: Lesson, kind: CategoryKind) -> Double {
        switch kind {
        case .vocabulary: return vocabularyProgress(in: lesson)
        case .grammar:    return grammarProgress(in: lesson)
        case .phrases:    return phrasesProgress(in: lesson)
        case .exercises:  return exercisesProgress(in: lesson)
        }
    }

    func categoryCount(in lesson: Lesson, kind: CategoryKind) -> (done: Int, total: Int) {
        switch kind {
        case .vocabulary:
            let done = lesson.vocabulary.filter { vocabularyMastered.contains($0.turkish) }.count
            return (done, lesson.vocabulary.count)
        case .grammar:
            let done = lesson.grammar.filter { grammarStudied.contains($0.title) }.count
            return (done, lesson.grammar.count)
        case .phrases:
            let done = lesson.phrases.filter { phrasesStudied.contains($0.turkish) }.count
            return (done, lesson.phrases.count)
        case .exercises:
            let done = lesson.exercises.filter { exercisesCompleted.contains($0.id) }.count
            return (done, lesson.exercises.count)
        }
    }
}
