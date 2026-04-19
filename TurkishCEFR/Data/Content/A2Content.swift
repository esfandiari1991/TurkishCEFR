import Foundation

// A2 — Elementary. Starter scaffold with representative lessons.
// Extend with full curriculum content over time.
enum A2Content {
    static let lessons: [Lesson] = [
        Lesson(
            id: "a2-past-tense",
            level: .a2,
            number: 1,
            titleTR: "Görülen Geçmiş Zaman: -di",
            titleEN: "Simple Past Tense",
            summary: "Talk about finished actions using -dI/-tI. Essential for narrating yesterday, last year, or any completed event.",
            systemImage: "arrow.uturn.backward.circle.fill",
            vocabulary: [
                VocabularyItem("dün", "yesterday", .adverb),
                VocabularyItem("geçen hafta", "last week", .phrase),
                VocabularyItem("geçen yıl", "last year", .phrase),
                VocabularyItem("önce", "ago / before", .adverb),
                VocabularyItem("hatırlamak", "to remember", .verb),
                VocabularyItem("unutmak", "to forget", .verb)
            ],
            grammar: [
                GrammarNote(
                    title: "The -dI past tense",
                    explanation: "Attach -dI (harmony: -dı/-di/-du/-dü, or -tı/-ti/-tu/-tü after voiceless consonants) then the past-tense personal ending (-m, -n, ∅, -k, -nız, -lar).",
                    examples: [
                        Phrase("Geldim.", "I came."),
                        Phrase("Gittin.", "You went."),
                        Phrase("Yedi.", "He/She ate."),
                        Phrase("Konuştuk.", "We talked.")
                    ]
                )
            ],
            phrases: [
                Phrase("Dün sinemaya gittim.", "Yesterday I went to the cinema.")
            ],
            exercises: [
                .fillInBlank(FillInBlankQuestion(
                    "a2-past-fb1", "Dün Ankara'ya git___.",
                    answer: "tim", translation: "Yesterday I went to Ankara."
                ))
            ]
        ),
        Lesson(
            id: "a2-future",
            level: .a2,
            number: 2,
            titleTR: "Gelecek Zaman: -acak",
            titleEN: "Future Tense",
            summary: "Talk about plans and predictions with the -(y)AcAK suffix.",
            systemImage: "arrow.forward.circle.fill",
            vocabulary: [
                VocabularyItem("yarın", "tomorrow", .adverb),
                VocabularyItem("gelecek hafta", "next week", .phrase),
                VocabularyItem("plan", "plan")
            ],
            grammar: [
                GrammarNote(
                    title: "-(y)acak / -(y)ecek",
                    explanation: "Harmony: -acak after back vowels, -ecek after front. Insert buffer 'y' after vowel stems.",
                    examples: [
                        Phrase("Yarın geleceğim.", "I will come tomorrow."),
                        Phrase("Okuyacak.", "He/She will read.")
                    ]
                )
            ],
            phrases: [
                Phrase("Hafta sonu ne yapacaksın?", "What will you do this weekend?")
            ],
            exercises: []
        ),
        Lesson(
            id: "a2-accusative",
            level: .a2,
            number: 3,
            titleTR: "Belirtme Hâli",
            titleEN: "Accusative Case",
            summary: "Learn when and how to mark the definite direct object with -(y)I.",
            systemImage: "arrow.right.square.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "When to use accusative",
                    explanation: "Mark specific/known direct objects. Unmarked objects are generic. 'Kitap okuyorum' = I'm reading (a/some) book. 'Kitabı okuyorum' = I'm reading the book.",
                    examples: [
                        Phrase("Kitabı okuyorum.", "I'm reading the book."),
                        Phrase("Seni seviyorum.", "I love you.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        )
    ]
}
