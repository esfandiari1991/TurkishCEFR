import Foundation

@MainActor
final class CurriculumStore: ObservableObject {
    @Published private(set) var lessonsByLevel: [CEFRLevel: [Lesson]] = [:]

    init() {
        lessonsByLevel[.a1] = A1Content.lessons
        lessonsByLevel[.a2] = A2Content.lessons
        lessonsByLevel[.b1] = B1Content.lessons
        lessonsByLevel[.b2] = B2Content.lessons
        lessonsByLevel[.c1] = C1Content.lessons
        lessonsByLevel[.c2] = C2Content.lessons
    }

    func lessons(for level: CEFRLevel) -> [Lesson] {
        lessonsByLevel[level] ?? []
    }

    func lesson(id: String) -> Lesson? {
        for (_, lessons) in lessonsByLevel {
            if let found = lessons.first(where: { $0.id == id }) {
                return found
            }
        }
        return nil
    }

    /// Flat list of every lesson across every level, stable-ordered by CEFR level then lesson number.
    var allLessons: [Lesson] {
        CEFRLevel.allCases.flatMap { lessonsByLevel[$0] ?? [] }
    }
}
