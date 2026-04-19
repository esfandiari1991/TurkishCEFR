import Foundation

struct Lesson: Identifiable, Hashable, Codable {
    let id: String
    let level: CEFRLevel
    let number: Int
    let titleTR: String
    let titleEN: String
    let summary: String
    let systemImage: String
    let vocabulary: [VocabularyItem]
    let grammar: [GrammarNote]
    let phrases: [Phrase]
    let exercises: [Exercise]

    var subtitle: String { "\(titleTR) · \(titleEN)" }
    var estimatedMinutes: Int {
        max(6, (vocabulary.count + grammar.count * 3 + exercises.count * 2) / 2)
    }
}

struct Phrase: Hashable, Codable {
    let turkish: String
    let english: String
    let note: String?

    init(_ turkish: String, _ english: String, note: String? = nil) {
        self.turkish = turkish
        self.english = english
        self.note = note
    }
}
