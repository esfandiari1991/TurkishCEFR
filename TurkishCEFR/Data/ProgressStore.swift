import Foundation
import Combine

@MainActor
final class ProgressStore: ObservableObject {
    @Published var lessonProgress: [String: LessonProgress] = [:]
    @Published var streakDays: Int = 0
    @Published var lastOpenedDate: Date?

    private let defaultsKey = "TurkishCEFR.progress.v1"

    init() {
        load()
    }

    subscript(lessonID: String) -> LessonProgress {
        get { lessonProgress[lessonID] ?? LessonProgress() }
        set {
            lessonProgress[lessonID] = newValue
            save()
        }
    }

    func markCompleted(_ lessonID: String) {
        var p = self[lessonID]
        p.completed = true
        p.lastStudied = Date()
        self[lessonID] = p
    }

    func markExerciseCompleted(lessonID: String, exerciseID: String) {
        var p = self[lessonID]
        p.exercisesCompleted.insert(exerciseID)
        p.lastStudied = Date()
        self[lessonID] = p
    }

    func toggleMastered(lessonID: String, word: String) {
        var p = self[lessonID]
        if p.vocabularyMastered.contains(word) {
            p.vocabularyMastered.remove(word)
        } else {
            p.vocabularyMastered.insert(word)
        }
        p.lastStudied = Date()
        self[lessonID] = p
    }

    func completion(for lessons: [Lesson]) -> Double {
        guard !lessons.isEmpty else { return 0 }
        let total = lessons.reduce(0.0) { $0 + self[$1.id].score }
        return total / Double(lessons.count)
    }

    func resetLevel(_ level: CEFRLevel, lessons: [Lesson]) {
        for lesson in lessons {
            lessonProgress.removeValue(forKey: lesson.id)
        }
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else { return }
        if let decoded = try? JSONDecoder().decode(Snapshot.self, from: data) {
            self.lessonProgress = decoded.lessonProgress
            self.streakDays = decoded.streakDays
            self.lastOpenedDate = decoded.lastOpenedDate
        }
    }

    private func save() {
        let snapshot = Snapshot(
            lessonProgress: lessonProgress,
            streakDays: streakDays,
            lastOpenedDate: lastOpenedDate
        )
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private struct Snapshot: Codable {
        var lessonProgress: [String: LessonProgress]
        var streakDays: Int
        var lastOpenedDate: Date?
    }
}
