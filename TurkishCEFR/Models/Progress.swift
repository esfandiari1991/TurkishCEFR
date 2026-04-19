import Foundation

struct LessonProgress: Codable, Hashable {
    var completed: Bool = false
    var vocabularyMastered: Set<String> = []
    var exercisesCompleted: Set<String> = []
    var lastStudied: Date?

    var score: Double {
        // Rough completion score used for ring UI.
        var total: Double = 0
        if completed { total += 0.5 }
        total += min(0.25, Double(vocabularyMastered.count) * 0.02)
        total += min(0.25, Double(exercisesCompleted.count) * 0.1)
        return min(1.0, total)
    }
}
