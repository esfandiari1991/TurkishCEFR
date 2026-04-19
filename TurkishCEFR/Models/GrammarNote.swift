import Foundation

struct GrammarNote: Identifiable, Hashable, Codable {
    var id: String { title }
    let title: String
    let explanation: String
    let examples: [Phrase]

    // Rich structured fields — default values keep old call sites valid.
    let intro: String?
    let rules: [GrammarRule]
    let patterns: [GrammarPattern]
    let pitfalls: [String]
    let summary: String?

    init(title: String,
         explanation: String,
         examples: [Phrase] = [],
         intro: String? = nil,
         rules: [GrammarRule] = [],
         patterns: [GrammarPattern] = [],
         pitfalls: [String] = [],
         summary: String? = nil) {
        self.title = title
        self.explanation = explanation
        self.examples = examples
        self.intro = intro
        self.rules = rules
        self.patterns = patterns
        self.pitfalls = pitfalls
        self.summary = summary
    }

    var hasRichDetail: Bool {
        intro != nil || !rules.isEmpty || !patterns.isEmpty ||
        !pitfalls.isEmpty || summary != nil
    }
}

/// A single structured rule — typically a suffix pattern or formation formula.
struct GrammarRule: Identifiable, Hashable, Codable {
    var id: String { label }
    let label: String
    let formula: String
    let note: String?

    init(_ label: String, _ formula: String, note: String? = nil) {
        self.label = label
        self.formula = formula
        self.note = note
    }
}

/// A subsection of a grammar note with its own heading, explanation, and examples.
struct GrammarPattern: Identifiable, Hashable, Codable {
    var id: String { heading }
    let heading: String
    let body: String
    let examples: [Phrase]

    init(_ heading: String, _ body: String, examples: [(String, String)] = []) {
        self.heading = heading
        self.body = body
        self.examples = examples.map { Phrase($0.0, $0.1) }
    }
}

/// Convenience builder for rich grammar notes.
@inline(__always)
func G(_ title: String,
       _ explanation: String,
       intro: String? = nil,
       rules: [GrammarRule] = [],
       patterns: [GrammarPattern] = [],
       ex: [(String, String)] = [],
       pitfalls: [String] = [],
       summary: String? = nil) -> GrammarNote {
    GrammarNote(
        title: title,
        explanation: explanation,
        examples: ex.map { Phrase($0.0, $0.1) },
        intro: intro,
        rules: rules,
        patterns: patterns,
        pitfalls: pitfalls,
        summary: summary
    )
}

@inline(__always)
func R(_ label: String, _ formula: String, _ note: String? = nil) -> GrammarRule {
    GrammarRule(label, formula, note: note)
}

@inline(__always)
func P(_ heading: String, _ body: String, ex: [(String, String)] = []) -> GrammarPattern {
    GrammarPattern(heading, body, examples: ex)
}
