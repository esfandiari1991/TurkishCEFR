import Foundation

// B1 — Intermediate. Scaffold.
enum B1Content {
    static let lessons: [Lesson] = [
        Lesson(
            id: "b1-conditional",
            level: .b1,
            number: 1,
            titleTR: "Şart Kipi: -se / -sa",
            titleEN: "Conditional Mood",
            summary: "Hypothesise and suppose: 'if I go', 'if you knew'.",
            systemImage: "questionmark.diamond.fill",
            vocabulary: [
                VocabularyItem("eğer", "if", .conjunction)
            ],
            grammar: [
                GrammarNote(
                    title: "-se / -sa",
                    explanation: "Attach -se (front) or -sa (back) to the verb stem or to -dI/-AcAK to form real and unreal conditions.",
                    examples: [
                        Phrase("Gelirsen, mutlu olurum.", "If you come, I'll be happy."),
                        Phrase("Bilseydim, söylerdim.", "If I had known, I would have said.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        ),
        Lesson(
            id: "b1-aorist",
            level: .b1,
            number: 2,
            titleTR: "Geniş Zaman: -Ir",
            titleEN: "Aorist / Habitual Tense",
            summary: "Express habits, general truths, and polite offers.",
            systemImage: "repeat.circle.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "-Ir / -Ar",
                    explanation: "The aorist (geniş zaman) is used for habits and generalisations. 'Her gün çay içerim' — I drink tea every day.",
                    examples: [
                        Phrase("Çay içer misiniz?", "Would you like some tea?"),
                        Phrase("Türkiye'de yaz sıcak olur.", "Summers in Turkey are hot.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        )
    ]
}
