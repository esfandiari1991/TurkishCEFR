import Foundation

// B2 — Upper-Intermediate. Scaffold.
enum B2Content {
    static let lessons: [Lesson] = [
        Lesson(
            id: "b2-passive",
            level: .b2,
            number: 1,
            titleTR: "Edilgen Çatı",
            titleEN: "Passive Voice",
            summary: "Form and use passives — crucial for formal and written Turkish.",
            systemImage: "arrowshape.turn.up.left.2.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "-Il / -In / -n",
                    explanation: "Choose the passive suffix by the verb stem's final sound. 'yap-ıl-' (to be done), 'gör-ül-' (to be seen), 'oku-n-' (to be read).",
                    examples: [
                        Phrase("Bu kitap çok okunuyor.", "This book is widely read."),
                        Phrase("Ev satıldı.", "The house was sold.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        ),
        Lesson(
            id: "b2-causative",
            level: .b2,
            number: 2,
            titleTR: "Ettirgen Çatı",
            titleEN: "Causative Voice",
            summary: "'Make someone do something' — an essential Turkish construction.",
            systemImage: "person.2.crop.square.stack.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "-DIr / -t / -Ir",
                    explanation: "The causative adds a layer meaning 'to cause/let X'. 'yap → yaptır' (to have done), 'öğrenmek → öğretmek' (to teach = cause to learn).",
                    examples: [
                        Phrase("Saçımı kestirdim.", "I had my hair cut."),
                        Phrase("Bana Türkçe öğretti.", "He taught me Turkish.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        )
    ]
}
