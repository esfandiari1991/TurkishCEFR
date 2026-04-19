import Foundation

// C2 — Mastery. Scaffold.
enum C2Content {
    static let lessons: [Lesson] = [
        Lesson(
            id: "c2-register",
            level: .c2,
            number: 1,
            titleTR: "Üslûp ve Kayıt",
            titleEN: "Register & Style",
            summary: "Navigate formal, colloquial, literary, and Ottoman-flavoured Turkish with confidence.",
            systemImage: "text.book.closed.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "Archaic and literary forms",
                    explanation: "Modern Turkish still draws on Ottoman vocabulary and Arabic-Persian loanwords in formal writing. Master tone, precision, and idiomatic phrasing.",
                    examples: [
                        Phrase("müsaade eder misiniz?", "would you permit me? (formal)"),
                        Phrase("teşekkür ederim → teşekkürler → sağ ol", "decreasing formality")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        ),
        Lesson(
            id: "c2-idioms",
            level: .c2,
            number: 2,
            titleTR: "Deyimler ve Atasözleri",
            titleEN: "Idioms & Proverbs",
            summary: "Use idioms and proverbs like a native speaker.",
            systemImage: "quote.bubble.fill",
            vocabulary: [],
            grammar: [],
            phrases: [
                Phrase("Damlaya damlaya göl olur.", "Drop by drop, a lake forms."),
                Phrase("Ağaç yaş iken eğilir.", "A tree is bent while young."),
                Phrase("Sakla samanı, gelir zamanı.", "Save the straw; its time will come.")
            ],
            exercises: []
        )
    ]
}
