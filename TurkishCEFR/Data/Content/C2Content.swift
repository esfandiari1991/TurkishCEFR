import Foundation

// MARK: - C2 Curriculum (CEFR Mastery)
// 4 lessons: Ottoman-inflected vocabulary, poetic register, proverbs,
// register switching, and nuanced stylistic choice.

enum C2Content {
    static let lessons: [Lesson] = [
        lesson01, lesson02, lesson03, lesson04
    ]

    private static func L(_ n: Int, _ suffix: String,
                          titleTR: String, titleEN: String,
                          summary: String, systemImage: String,
                          vocab: [VocabularyItem] = [],
                          grammar: [GrammarNote] = [],
                          phrases: [Phrase] = [],
                          exercises: [Exercise] = []) -> Lesson {
        Lesson(id: "c2-\(suffix)", level: .c2, number: n,
               titleTR: titleTR, titleEN: titleEN, summary: summary,
               systemImage: systemImage,
               vocabulary: vocab, grammar: grammar,
               phrases: phrases, exercises: exercises)
    }

    // MARK: 1. Proverbs
    static let lesson01 = L(
        1, "proverbs",
        titleTR: "Atasözleri",
        titleEN: "Proverbs",
        summary: "A curated set of proverbs that every fluent Turkish speaker knows.",
        systemImage: "books.vertical.fill",
        vocab: [
            V("damlaya damlaya göl olur", "drop by drop a lake forms", .phrase,
              def: "patience and persistence yield great results"),
            V("ak akçe kara gün içindir", "a white coin is for a dark day", .phrase,
              def: "save money for a rainy day"),
            V("son gülen iyi güler", "he who laughs last laughs best", .phrase),
            V("ne ekersen onu biçersin", "you reap what you sow", .phrase),
            V("emek vermeden meyve yenmez", "you can't eat fruit without labour", .phrase)
        ],
        grammar: [],
        phrases: [
            Phrase("Damlaya damlaya göl olur.", "Drop by drop, a lake is formed."),
            Phrase("Ak akçe kara gün içindir.", "Save for a rainy day."),
            Phrase("Son gülen iyi güler.", "He who laughs last laughs best.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "c2-prov-fc", cards: [
                VocabularyItem("damlaya damlaya göl olur", "drop by drop a lake forms", .phrase),
                VocabularyItem("son gülen iyi güler", "he who laughs last laughs best", .phrase),
                VocabularyItem("ne ekersen onu biçersin", "you reap what you sow", .phrase)
            ]))
        ]
    )

    // MARK: 2. Ottoman-flavour vocabulary
    static let lesson02 = L(
        2, "ottoman",
        titleTR: "Osmanlıca Söz Dağarcığı",
        titleEN: "Ottoman-Flavoured Vocabulary",
        summary: "Arabic- and Persian-origin words that colour elevated and literary Turkish.",
        systemImage: "scroll.fill",
        vocab: [
            V("muhabbet", "affection · conversation", .noun,
              def: "pleasant conversation or affection", etym: "Arabic ḥabba 'to love'"),
            V("tahammül", "tolerance · endurance", .noun, etym: "Arabic"),
            V("istikamet", "direction · course", .noun, etym: "Arabic"),
            V("tesadüf", "coincidence", .noun, etym: "Arabic"),
            V("mütevazı", "humble", .adjective, etym: "Arabic"),
            V("serüven", "adventure", .noun, etym: "Persian"),
            V("âşık", "lover · enamoured", .adjective, etym: "Arabic"),
            V("hüzün", "deep melancholy", .noun, etym: "Arabic; cf. Orhan Pamuk's 'hüzün'")
        ],
        grammar: [],
        phrases: [
            Phrase("Bu tesadüf değil, kaderdir.", "This isn't coincidence — it's fate."),
            Phrase("Mütevazı bir hayat sürüyor.", "He leads a humble life.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "c2-otto-mc1", "'hüzün' best translates as:",
                ["joy", "melancholy", "coincidence", "patience"],
                correct: 1
            ))
        ]
    )

    // MARK: 3. Poetic register
    static let lesson03 = L(
        3, "poetry",
        titleTR: "Şiirsel Dil",
        titleEN: "Poetic Register",
        summary: "Inversions, sound play, and metaphor typical of Turkish poetry.",
        systemImage: "music.note.list",
        grammar: [
            G("Poetic inversion",
              "Turkish allows very free word order for emphasis and rhythm. In poetry the verb may come first or last out of usual SOV order.",
              patterns: [
                P("Inversion for emphasis",
                  "",
                  ex: [("Geldin mi sen, benim güzelim?", "Have you come, my beautiful one?"),
                       ("Ağlama annem, döneceğim.", "Don't cry, mother, I'll return.")])
              ]),
            G("Sound play & rhyme",
              "Repetition, alliteration, and rhyme are central.",
              patterns: [
                P("Alliteration",
                  "",
                  ex: [("Karanlıkta kaybolup kaldım.", "I got lost in the dark.")])
              ])
        ],
        phrases: [
            Phrase("Sensiz bir bahçeyim, gülsüz, bülbülsüz.", "Without you I'm a garden without roses, without nightingales.")
        ],
        exercises: []
    )

    // MARK: 4. Register switching
    static let lesson04 = L(
        4, "register-switch",
        titleTR: "Biçem Geçişleri",
        titleEN: "Register & Style Switching",
        summary: "Recognise and deploy the right register for context: boardroom, street, poem, newspaper.",
        systemImage: "arrow.left.arrow.right",
        grammar: [
            G("Register choice",
              "Native speakers juggle several registers fluidly. A fluent C2 learner does too.",
              patterns: [
                P("Formal",
                  "Arabic/Persian roots, passive, long sentences",
                  ex: [("Bu bağlamda, söz konusu mesele ele alınmalıdır.",
                        "In this context, the matter in question must be addressed.")]),
                P("Neutral written",
                  "",
                  ex: [("Bu konuda ne düşünüyorsunuz?", "What do you think about this?")]),
                P("Colloquial",
                  "Fillers, fragments, shortening",
                  ex: [("Abi, ne diyonsun ya?", "Dude, what're you even saying?")])
              ])
        ],
        phrases: [
            Phrase("Rica ederim, bu konuyu tartışalım.", "Please, let's discuss this matter."),
            Phrase("Hadi be, böyle şey olur mu?", "Come on, does that even make sense?")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "c2-reg-mc1", "Which is the MOST formal equivalent?",
                ["abi, ne oldu?", "ne oldu ya?", "ne oldu?", "ne vuku buldu?"],
                correct: 3,
                explanation: "'vuku buldu' is Ottoman-style very formal for 'occurred'."
            ))
        ]
    )
}
