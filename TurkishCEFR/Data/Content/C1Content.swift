import Foundation

// MARK: - C1 Curriculum (CEFR Advanced)
// 5 lessons: nominalised clauses, participles & non-finite verb forms, formal
// written register, figurative language, advanced discourse.

enum C1Content {
    static let lessons: [Lesson] = [
        lesson01, lesson02, lesson03, lesson04, lesson05
    ]

    private static func L(_ n: Int, _ suffix: String,
                          titleTR: String, titleEN: String,
                          summary: String, systemImage: String,
                          vocab: [VocabularyItem] = [],
                          grammar: [GrammarNote] = [],
                          phrases: [Phrase] = [],
                          exercises: [Exercise] = []) -> Lesson {
        Lesson(id: "c1-\(suffix)", level: .c1, number: n,
               titleTR: titleTR, titleEN: titleEN, summary: summary,
               systemImage: systemImage,
               vocabulary: vocab, grammar: grammar,
               phrases: phrases, exercises: exercises)
    }

    // MARK: 1. Nominalised clauses -mAk / -mA / -Iş
    static let lesson01 = L(
        1, "nominal",
        titleTR: "Ad-Fiil: -mAk / -mA / -Iş",
        titleEN: "Verbal Nouns · Nominalised Clauses",
        summary: "Turn a whole clause into a noun-like phrase. Essential for elegant, written Turkish.",
        systemImage: "text.book.closed.fill",
        grammar: [
            G("-mAk — the infinitive",
              "Used as a subject or object of another verb, like English '-ing' or 'to-'",
              patterns: [
                P("As subject",
                  "Yüzmek zordur. 'Swimming is hard.'",
                  ex: [("Yüzmek zordur.", "Swimming is hard."),
                       ("Onu görmek istemedim.", "I didn't want to see him.")]),
                P("With postpositions",
                  "-mAk için, -mAk üzere, -mAk için, -mAktan",
                  ex: [("Okumaktan zevk alırım.", "I enjoy reading.")])
              ]),
            G("-mA — 'the fact of -ing'",
              "More nominal than -mAk; acts like a noun taking case markers.",
              patterns: [
                P("Factive",
                  "",
                  ex: [("Gelmen güzel.", "Your coming (the fact you came) is nice."),
                       ("Senin gelmen önemli.", "Your coming is important.")])
              ]),
            G("-Iş — manner of doing",
              "Expresses the manner, style, or act of an activity.",
              patterns: [
                P("Style",
                  "",
                  ex: [("Bakışı tanıdık geldi.", "The way he looked was familiar."),
                       ("Bu çocuğun yürüyüşüne bak.", "Look at the way this child walks.")])
              ])
        ],
        phrases: [
            Phrase("Yüzmek çok keyifli.", "Swimming is very enjoyable."),
            Phrase("Gelmen güzel oldu.", "It's nice that you came."),
            Phrase("Onun konuşuşu çok güzel.", "Her way of speaking is lovely.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "c1-nom-mc1", "'Swimming is hard.' =",
                ["Yüzdüm zor.", "Yüzmek zor.", "Yüzeceğim.", "Yüzüyorum."],
                correct: 1
            ))
        ]
    )

    // MARK: 2. Participles
    static let lesson02 = L(
        2, "participles",
        titleTR: "Sıfat-Fiil",
        titleEN: "Participles",
        summary: "-(y)AcAK (future), -mIş (perfect), -(y)An (subject), -DIK (object) used as adjectives and noun-phrase heads.",
        systemImage: "textformat.size",
        grammar: [
            G("Future participle -(y)AcAK",
              "'The thing that will be done'",
              patterns: [
                P("Example",
                  "yazılacak mektup 'the letter to be written'",
                  ex: [("yapılacak iş", "the work to be done"),
                       ("izleyeceğim film", "the film I will watch")])
              ]),
            G("Perfect participle -mIş",
              "'Done, completed'",
              patterns: [
                P("Example",
                  "pişmiş yemek 'cooked food'",
                  ex: [("unutulmuş hatıra", "a forgotten memory"),
                       ("kırılmış cam", "broken glass")])
              ]),
            G("-(y)An & -DIK revisited (advanced use)",
              "Chain participles for complex noun phrases.",
              patterns: [
                P("Chained",
                  "",
                  ex: [("dün gördüğüm ve beğendiğim film", "the film I saw and liked yesterday")])
              ])
        ],
        phrases: [
            Phrase("Kırılmış bir kalp gibiyim.", "I feel like a broken heart."),
            Phrase("Yapılacak çok iş var.", "There's a lot of work to do.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "c1-par-mc1", "'The film I will watch' =",
                ["izleyen film", "izlediğim film", "izleyeceğim film", "izlemek film"],
                correct: 2
            ))
        ]
    )

    // MARK: 3. Formal register
    static let lesson03 = L(
        3, "formal",
        titleTR: "Resmî Dil",
        titleEN: "Formal Register & Writing",
        summary: "Academic and formal Turkish conventions: passive style, long sentences, nominalised syntax.",
        systemImage: "doc.text.fill",
        vocab: [
            V("bu bağlamda", "in this context", .phrase),
            V("dolayısıyla", "consequently", .adverb),
            V("bunun yanı sıra", "in addition", .phrase),
            V("öte yandan", "on the other hand", .phrase),
            V("nihayetinde", "ultimately", .adverb)
        ],
        grammar: [
            G("Discourse markers in formal writing",
              "Formal Turkish prefers long, nominalised sentences with explicit connectors.",
              patterns: [
                P("Listing",
                  "'ilk olarak', 'ikincisi', 'son olarak'",
                  ex: [("İlk olarak, mevcut duruma bakalım.", "First, let's look at the current situation.")]),
                P("Contrast",
                  "'ancak', 'fakat', 'öte yandan'",
                  ex: [("Ancak bu görüş tartışmalıdır.", "However, this view is debatable.")]),
                P("Cause / consequence",
                  "'dolayısıyla', 'bu nedenle', 'bu yüzden'",
                  ex: [("Dolayısıyla bu politika başarısız oldu.", "Consequently, this policy failed.")])
              ])
        ],
        phrases: [
            Phrase("Bu çalışmada aşağıdaki sorulara cevap aranmıştır.",
                   "This study seeks answers to the following questions."),
            Phrase("Sonuç olarak, elde edilen bulgular tutarlıdır.",
                   "In conclusion, the obtained findings are consistent.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "c1-form-mc1", "Which is most formal for 'therefore'?",
                ["yani", "dolayısıyla", "işte", "şey"],
                correct: 1
            ))
        ]
    )

    // MARK: 4. Idioms
    static let lesson04 = L(
        4, "idioms",
        titleTR: "Deyimler",
        titleEN: "Idioms · Figurative Language",
        summary: "Colourful idioms native speakers use daily.",
        systemImage: "sparkles",
        vocab: [
            V("göz atmak", "to glance at", .verb,
              def: "lit. 'to throw an eye'",
              ex: [("Şu rapora bir göz at.", "Take a look at this report.")]),
            V("baş ağrısı", "headache · annoyance", .phrase,
              def: "also used figuratively for any nuisance",
              ex: [("Bu iş büyük bir baş ağrısı.", "This job is a big headache.")]),
            V("ayıkla pirincin taşını", "sort out the mess", .phrase,
              def: "lit. 'pick the stones out of the rice'"),
            V("kuş uçmaz kervan geçmez", "remote middle of nowhere", .phrase,
              def: "lit. 'no bird flies, no caravan passes'")
        ],
        grammar: [],
        phrases: [
            Phrase("Şu rapora bir göz at.", "Take a look at this report."),
            Phrase("Ayıkla pirincin taşını!", "Now sort out the mess!"),
            Phrase("Burası kuş uçmaz kervan geçmez bir yer.", "This is the middle of nowhere.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "c1-id-fc", cards: [
                VocabularyItem("göz atmak", "to glance at", .phrase),
                VocabularyItem("baş ağrısı", "headache / nuisance", .phrase),
                VocabularyItem("ayıkla pirincin taşını", "sort out the mess", .phrase),
                VocabularyItem("kuş uçmaz kervan geçmez", "remote place", .phrase)
            ]))
        ]
    )

    // MARK: 5. Discourse connectives
    static let lesson05 = L(
        5, "discourse",
        titleTR: "Metinde Bağlantı",
        titleEN: "Discourse Connectives",
        summary: "Structure long arguments with native cohesion devices.",
        systemImage: "text.alignleft",
        grammar: [
            G("Cohesion in extended discourse",
              "Turkish relies on nominalised clauses and postposed connectors more than English.",
              patterns: [
                P("Listing",
                  "önce, ardından, sonra, nihayet",
                  ex: [("Önce kahvaltı yaptık, ardından yola çıktık, nihayet İzmir'e vardık.",
                        "First we had breakfast, then we set off, and finally we reached İzmir.")]),
                P("Contrast",
                  "her ne kadar … olsa da",
                  ex: [("Her ne kadar yorgun olsa da toplantıya katıldı.",
                        "Although he was tired, he attended the meeting.")])
              ])
        ],
        phrases: [
            Phrase("Her ne kadar yorgun olsam da sizinle geliyorum.",
                   "Although I'm tired, I'm coming with you."),
            Phrase("Nihayetinde, kararınızı siz vereceksiniz.",
                   "Ultimately, you will make your decision.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "c1-disc-mc1", "Choose the best connector for 'although':",
                ["çünkü", "dolayısıyla", "her ne kadar … olsa da", "ve"],
                correct: 2
            ))
        ]
    )
}
