import Foundation

enum Exercise: Identifiable, Hashable, Codable {
    case flashcard(FlashcardSet)
    case multipleChoice(MultipleChoiceQuestion)
    case fillInBlank(FillInBlankQuestion)
    case listening(ListeningPrompt)

    var id: String {
        switch self {
        case .flashcard(let s): return "fc-\(s.id)"
        case .multipleChoice(let q): return "mc-\(q.id)"
        case .fillInBlank(let q): return "fb-\(q.id)"
        case .listening(let p): return "ls-\(p.id)"
        }
    }

    var title: String {
        switch self {
        case .flashcard:      return "Flashcards"
        case .multipleChoice: return "Multiple Choice"
        case .fillInBlank:    return "Fill in the Blank"
        case .listening:      return "Listening"
        }
    }

    var systemImage: String {
        switch self {
        case .flashcard:      return "rectangle.on.rectangle.angled"
        case .multipleChoice: return "checklist"
        case .fillInBlank:    return "text.cursor"
        case .listening:      return "ear.and.waveform"
        }
    }

    /// Ordering key for the progressive Learn → Practice → Test → Listen flow.
    var orderRank: Int {
        switch self {
        case .flashcard:      return 0
        case .multipleChoice: return 1
        case .fillInBlank:    return 2
        case .listening:      return 3
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
    /// Optional per-option rationale. When provided, the learner sees a
    /// targeted explanation for **every** distractor they pick — including
    /// the right one — instead of a single verdict. This is what turns a
    /// pass/fail quiz into a teaching tool: "Why is this wrong?" rather
    /// than just "Wrong."
    ///
    /// If present the length must match `choices.count`.
    let rationales: [String]?

    init(_ id: String,
         _ prompt: String,
         _ choices: [String],
         correct: Int,
         explanation: String? = nil,
         rationales: [String]? = nil) {
        self.id = id
        self.prompt = prompt
        self.choices = choices
        self.correctIndex = correct
        self.explanation = explanation
        self.rationales = rationales
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

/// Listening exercise — the app speaks a Turkish prompt and the learner types
/// what they hear. Comparison is normalised (case-insensitive + punctuation stripped).
struct ListeningPrompt: Identifiable, Hashable, Codable {
    let id: String
    let turkish: String
    let english: String
    let hint: String?

    init(_ id: String, _ turkish: String, english: String, hint: String? = nil) {
        self.id = id
        self.turkish = turkish
        self.english = english
        self.hint = hint
    }
}

/// Concise builder for listening prompts so content files stay tidy.
@inline(__always)
func LSN(_ id: String, _ turkish: String, _ english: String, hint: String? = nil) -> Exercise {
    .listening(ListeningPrompt(id, turkish, english: english, hint: hint))
}
