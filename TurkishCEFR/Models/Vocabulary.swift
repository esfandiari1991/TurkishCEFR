import Foundation

struct VocabularyItem: Identifiable, Hashable, Codable {
    var id: String { turkish + "|" + english }
    let turkish: String
    let english: String
    let partOfSpeech: PartOfSpeech
    let exampleTR: String?
    let exampleEN: String?

    // Rich fields — optional so every existing call site keeps working.
    let ipa: String?
    let definitionTR: String?
    let definitionEN: String?
    let synonyms: [String]
    let antonyms: [String]
    let moreExamples: [Phrase]
    let usageNote: String?
    let etymology: String?

    init(_ turkish: String,
         _ english: String,
         _ partOfSpeech: PartOfSpeech = .noun,
         example: (String, String)? = nil,
         ipa: String? = nil,
         definitionTR: String? = nil,
         definitionEN: String? = nil,
         synonyms: [String] = [],
         antonyms: [String] = [],
         moreExamples: [(String, String)] = [],
         usageNote: String? = nil,
         etymology: String? = nil) {
        self.turkish = turkish
        self.english = english
        self.partOfSpeech = partOfSpeech
        self.exampleTR = example?.0
        self.exampleEN = example?.1
        self.ipa = ipa
        self.definitionTR = definitionTR
        self.definitionEN = definitionEN
        self.synonyms = synonyms
        self.antonyms = antonyms
        self.moreExamples = moreExamples.map { Phrase($0.0, $0.1) }
        self.usageNote = usageNote
        self.etymology = etymology
    }

    var hasRichDetail: Bool {
        definitionEN != nil || definitionTR != nil ||
        !synonyms.isEmpty || !antonyms.isEmpty ||
        !moreExamples.isEmpty || usageNote != nil || etymology != nil
    }
}

enum PartOfSpeech: String, Codable, Hashable {
    case noun, verb, adjective, adverb, pronoun, phrase, number, conjunction, preposition, interjection, particle, suffix

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
        case .preposition: return "postp."
        case .interjection: return "interj."
        case .particle: return "particle"
        case .suffix: return "suffix"
        }
    }
}

/// Convenience builder for rich vocabulary items. Keeps curriculum files terse.
@inline(__always)
func V(_ tr: String, _ en: String,
       _ pos: PartOfSpeech = .noun,
       ipa: String? = nil,
       def: String? = nil,
       defTR: String? = nil,
       ex: [(String, String)] = [],
       syn: [String] = [],
       ant: [String] = [],
       note: String? = nil,
       etym: String? = nil) -> VocabularyItem {
    VocabularyItem(
        tr, en, pos,
        example: ex.first,
        ipa: ipa,
        definitionTR: defTR,
        definitionEN: def,
        synonyms: syn,
        antonyms: ant,
        moreExamples: ex.count > 1 ? Array(ex.dropFirst()) : [],
        usageNote: note,
        etymology: etym
    )
}
