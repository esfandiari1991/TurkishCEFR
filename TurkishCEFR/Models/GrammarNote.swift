import Foundation

struct GrammarNote: Identifiable, Hashable, Codable {
    var id: String { title }
    let title: String
    let explanation: String
    let examples: [Phrase]
}
