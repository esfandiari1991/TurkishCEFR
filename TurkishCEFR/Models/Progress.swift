import Foundation

/// Per-lesson completion record. Every field has a sensible default so old saved
/// snapshots (which may not contain newer fields) keep working after an upgrade.
struct LessonProgress: Codable, Hashable {
    var completed: Bool = false
    var vocabularyMastered: Set<String> = []
    var grammarStudied: Set<String> = []
    var phrasesStudied: Set<String> = []
    var exercisesCompleted: Set<String> = []
    var lastStudied: Date?

    // MARK: Category progress (0...1)

    func vocabularyProgress(in lesson: Lesson) -> Double {
        guard !lesson.vocabulary.isEmpty else { return 0 }
        let mastered = lesson.vocabulary.filter { vocabularyMastered.contains($0.turkish) }.count
        return min(1.0, Double(mastered) / Double(lesson.vocabulary.count))
    }

    func grammarProgress(in lesson: Lesson) -> Double {
        guard !lesson.grammar.isEmpty else { return 0 }
        let studied = lesson.grammar.filter { grammarStudied.contains($0.title) }.count
        return min(1.0, Double(studied) / Double(lesson.grammar.count))
    }

    func phrasesProgress(in lesson: Lesson) -> Double {
        guard !lesson.phrases.isEmpty else { return 0 }
        let studied = lesson.phrases.filter { phrasesStudied.contains($0.turkish) }.count
        return min(1.0, Double(studied) / Double(lesson.phrases.count))
    }

    func exercisesProgress(in lesson: Lesson) -> Double {
        guard !lesson.exercises.isEmpty else { return 0 }
        let done = lesson.exercises.filter { exercisesCompleted.contains($0.id) }.count
        return min(1.0, Double(done) / Double(lesson.exercises.count))
    }

    func overallScore(in lesson: Lesson) -> Double {
        // Weighted average of the four categories. Categories with zero items are
        // simply skipped (weight 0) so lessons without phrases, grammar, etc.
        // still reach 100%.
        var total: Double = 0
        var weight: Double = 0
        if !lesson.vocabulary.isEmpty {
            total += vocabularyProgress(in: lesson); weight += 1
        }
        if !lesson.grammar.isEmpty {
            total += grammarProgress(in: lesson); weight += 1
        }
        if !lesson.phrases.isEmpty {
            total += phrasesProgress(in: lesson); weight += 1
        }
        if !lesson.exercises.isEmpty {
            total += exercisesProgress(in: lesson); weight += 1
        }
        guard weight > 0 else { return 0 }
        return min(1.0, total / weight)
    }

    /// Legacy rough score used in lists where we don't have the lesson context.
    var score: Double {
        var total: Double = 0
        if completed { total += 0.5 }
        total += min(0.25, Double(vocabularyMastered.count) * 0.02)
        total += min(0.25, Double(exercisesCompleted.count) * 0.1)
        return min(1.0, total)
    }

    // MARK: Tolerant Codable

    // Any new field added in a future version can just appear here with a
    // default in `init(from:)` so we never break older persisted snapshots.
    private enum CodingKeys: String, CodingKey {
        case completed, vocabularyMastered, grammarStudied, phrasesStudied,
             exercisesCompleted, lastStudied
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.completed            = (try? c.decode(Bool.self, forKey: .completed)) ?? false
        self.vocabularyMastered   = (try? c.decode(Set<String>.self, forKey: .vocabularyMastered)) ?? []
        self.grammarStudied       = (try? c.decode(Set<String>.self, forKey: .grammarStudied)) ?? []
        self.phrasesStudied       = (try? c.decode(Set<String>.self, forKey: .phrasesStudied)) ?? []
        self.exercisesCompleted   = (try? c.decode(Set<String>.self, forKey: .exercisesCompleted)) ?? []
        self.lastStudied          = try? c.decode(Date.self, forKey: .lastStudied)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(completed, forKey: .completed)
        try c.encode(vocabularyMastered, forKey: .vocabularyMastered)
        try c.encode(grammarStudied, forKey: .grammarStudied)
        try c.encode(phrasesStudied, forKey: .phrasesStudied)
        try c.encode(exercisesCompleted, forKey: .exercisesCompleted)
        try c.encodeIfPresent(lastStudied, forKey: .lastStudied)
    }
}
