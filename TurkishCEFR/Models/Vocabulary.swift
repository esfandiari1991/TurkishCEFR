import Foundation

struct VocabularyItem: Identifiable, Hashable, Codable {
    var id: String { turkish + "|" + english }
    let turkish: String
    let english: String
    let partOfSpeech: PartOfSpeech
    let exampleTR: String?
    let exampleEN: String?

    init(_ turkish: String,
         _ english: String,
         _ partOfSpeech: PartOfSpeech = .noun,
         example: (String, String)? = nil) {
        self.turkish = turkish
        self.english = english
        self.partOfSpeech = partOfSpeech
        self.exampleTR = example?.0
        self.exampleEN = example?.1
    }
}

enum PartOfSpeech: String, Codable, Hashable {
    case noun, verb, adjective, adverb, pronoun, phrase, number, conjunction, preposition, interjection

    var label: String {
        switch self {
        case .noun: return "noun"
        case .verb: return "verb"
        case .adjective: return "adj."
        case .adverb: return "adv."
        case .pronoun: return "pron."
        case .phrase: return "phrase"
        case .number: return "num."
        case .conjunction: return "conj."
        case .preposition: return "prep."
        case .interjection: return "interj."
        }
    }
}
