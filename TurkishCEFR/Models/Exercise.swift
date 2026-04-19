import Foundation

enum Exercise: Identifiable, Hashable, Codable {
    case flashcard(FlashcardSet)
    case multipleChoice(MultipleChoiceQuestion)
    case fillInBlank(FillInBlankQuestion)

    var id: String {
        switch self {
        case .flashcard(let s): return "fc-\(s.id)"
        case .multipleChoice(let q): return "mc-\(q.id)"
        case .fillInBlank(let q): return "fb-\(q.id)"
        }
    }

    var title: String {
        switch self {
        case .flashcard: return "Flashcards"
        case .multipleChoice: return "Multiple Choice"
        case .fillInBlank: return "Fill in the Blank"
        }
    }

    var systemImage: String {
        switch self {
        case .flashcard: return "rectangle.on.rectangle.angled"
        case .multipleChoice: return "checklist"
        case .fillInBlank: return "text.cursor"
        }
    }
}

struct FlashcardSet: Hashable, Codable {
    let id: String
    let cards: [VocabularyItem]
}

struct MultipleChoiceQuestion: Identifiable, Hashable, Codable {
    let id: String
    let prompt: String
    let choices: [String]
    let correctIndex: Int
    let explanation: String?

    init(_ id: String, _ prompt: String, _ choices: [String], correct: Int, explanation: String? = nil) {
        self.id = id
        self.prompt = prompt
        self.choices = choices
        self.correctIndex = correct
        self.explanation = explanation
    }
}

struct FillInBlankQuestion: Identifiable, Hashable, Codable {
    let id: String
    let sentence: String     // Use "___" as the blank marker
    let answer: String
    let translation: String
    let hint: String?

    init(_ id: String, _ sentence: String, answer: String, translation: String, hint: String? = nil) {
        self.id = id
        self.sentence = sentence
        self.answer = answer
        self.translation = translation
        self.hint = hint
    }
}
