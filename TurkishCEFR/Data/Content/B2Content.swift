import Foundation

// MARK: - B2 Curriculum (CEFR Upper-Intermediate)
// 5 lessons: passive & causative voices, converbs (-(y)Ip / -ArAk / -IncA),
// the pluperfect and habitual past, and subordination.

enum B2Content {
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
        Lesson(id: "b2-\(suffix)", level: .b2, number: n,
               titleTR: titleTR, titleEN: titleEN, summary: summary,
               systemImage: systemImage,
               vocabulary: vocab, grammar: grammar,
               phrases: phrases, exercises: exercises)
    }

    // MARK: 1. Passive voice
    static let lesson01 = L(
        1, "passive",
        titleTR: "Edilgen Çatı: -Il / -In",
        titleEN: "Passive Voice",
        summary: "Turn an active verb into a passive: 'the book was read', 'the door is opened'.",
        systemImage: "arrow.uturn.backward",
        grammar: [
            G("Passive suffixes -Il / -In",
              "Turkish has three allomorphs depending on the stem's final sound.",
              rules: [
                R("After consonant (not l)", "-Il", "yap-ıl-mak 'to be done'"),
                R("After vowel", "-n", "oku-n-mak 'to be read'"),
                R("After 'l'", "-In", "bul-un-mak 'to be found'"),
                R("Harmony", "vowel harmony applies", "four-way i-harmony")
              ],
              patterns: [
                P("Active → passive",
                  "Kapıyı açtım. → Kapı açıldı.",
                  ex: [("Kapı açıldı.", "The door was opened."),
                       ("Kitap okunuyor.", "The book is being read."),
                       ("Mektup yazıldı.", "The letter has been written.")]),
                P("Agent with 'tarafından'",
                  "Optional: 'X tarafından' = 'by X'",
                  ex: [("Mektup Ayşe tarafından yazıldı.", "The letter was written by Ayşe.")]),
                P("Impersonal passive",
                  "Intransitive verbs can form impersonal passives: 'Burada sigara içilmez.'",
                  ex: [("Burada sigara içilmez.", "Smoking is not allowed here."),
                       ("Türkçe konuşulur.", "Turkish is spoken.")])
              ],
              ex: [("Bu kitap çok okunuyor.", "This book is being read a lot.")],
              pitfalls: [
                "Choose allomorph by LAST SOUND of the stem, not the surface vowel.",
                "'Bulmak' → 'bulunmak' (after -l use -In)."
              ],
              summary: "Allomorph rule: consonant (except l) → -Il; vowel → -n; after 'l' → -In.")
        ],
        phrases: [
            Phrase("Burada Türkçe konuşulur.", "Turkish is spoken here."),
            Phrase("Bu ev 1923'te yapıldı.", "This house was built in 1923.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b2-pass-mc1", "Passive of 'yazmak' (to write) =",
                ["yazmak", "yazılmak", "yazdırmak", "yazmak"],
                correct: 1,
                explanation: "Consonant stem → -Il: yazılmak 'to be written'."
            ))
        ]
    )

    // MARK: 2. Causative
    static let lesson02 = L(
        2, "causative",
        titleTR: "Ettirgen Çatı: -DIr / -t / -Ir",
        titleEN: "Causative Voice",
        summary: "Make someone do something — 'I had it fixed', 'the teacher made the student read'.",
        systemImage: "hand.point.up.left.fill",
        grammar: [
            G("Causative suffixes",
              "Turkish has ~5 allomorphs. Which one a verb takes is lexical — memorise common ones.",
              rules: [
                R("Most common", "-DIr", "yap-tır-mak 'to have done'"),
                R("After vowel, some", "-t", "oku-t-mak 'to make read'"),
                R("Short stems", "-Ir", "iç-ir-mek 'to make drink', piş-ir-mek 'to cook'"),
                R("Rare", "-Ar / -Art", "çık-ar-mak 'to take out'")
              ],
              patterns: [
                P("One-level causative",
                  "yemek 'to eat' → yedirmek 'to feed'",
                  ex: [("Bebeğe mama yedirdim.", "I fed the baby."),
                       ("Saçımı kestirdim.", "I had my hair cut."),
                       ("Evi boyattım.", "I had the house painted.")]),
                P("Double causative",
                  "You can stack two: öl-dür-t-mek 'to have someone killed'",
                  ex: [("Arabayı yıkattırdım.", "I had someone wash the car.")])
              ],
              ex: [("Öğretmen öğrencileri konuşturdu.", "The teacher made the students speak.")],
              pitfalls: [
                "Never guess the allomorph — it's lexical. Use a dictionary until fluent.",
                "Object of the base verb becomes dative: 'bebeğe mama yedirmek'."
              ],
              summary: "Causative is lexical — learn pairs. Most common: -DIr.")
        ],
        phrases: [
            Phrase("Saçımı kestirdim.", "I had my hair cut."),
            Phrase("Arabayı tamir ettirdim.", "I had the car repaired.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b2-caus-mc1", "'I had my hair cut' =",
                ["Saçımı kestim.", "Saçımı kestirdim.", "Saçım kesildi.", "Saçım kesiyor."],
                correct: 1
            ))
        ]
    )

    // MARK: 3. Converbs
    static let lesson03 = L(
        3, "converbs",
        titleTR: "Zarf-Fiil: -(y)Ip, -ArAk, -IncA",
        titleEN: "Converbs · Linking Clauses",
        summary: "Chain actions compactly with -(y)Ip, -(y)ArAk, -(y)IncA.",
        systemImage: "link",
        grammar: [
            G("-(y)Ip — 'and then'",
              "Links two actions with the same subject and identical tense.",
              patterns: [
                P("Example",
                  "'I came home and ate.' = Eve gelip yemek yedim.",
                  ex: [("Eve gelip yattım.", "I came home and went to bed.")])
              ]),
            G("-(y)ArAk — 'by / while doing'",
              "Describes the MANNER in which the main action happens.",
              patterns: [
                P("Manner",
                  "",
                  ex: [("Gülerek konuştu.", "She spoke laughing / while laughing."),
                       ("Koşarak geldim.", "I came running."),
                       ("Çalışarak öğrendim.", "I learned by working.")])
              ]),
            G("-(y)IncA — 'when / as soon as'",
              "Marks a temporal clause meaning 'when X happens, Y'.",
              patterns: [
                P("Temporal",
                  "",
                  ex: [("Eve gelince ara beni.", "Call me when you get home."),
                       ("Onu görünce şaşırdım.", "I was surprised when I saw him.")])
              ])
        ],
        phrases: [
            Phrase("Eve gelip yattım.", "I came home and went to bed."),
            Phrase("Koşarak geldim.", "I came running."),
            Phrase("Onu görünce şaşırdım.", "I was surprised when I saw him.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b2-cv-mc1", "Which converb means 'by doing'?",
                ["-(y)Ip", "-(y)ArAk", "-(y)IncA", "-DIğInDA"],
                correct: 1
            ))
        ]
    )

    // MARK: 4. Pluperfect & past habitual
    static let lesson04 = L(
        4, "past-compound",
        titleTR: "Birleşik Geçmiş",
        titleEN: "Compound Past Tenses",
        summary: "Express 'had done' (pluperfect) and 'used to do' (past habitual).",
        systemImage: "clock.arrow.circlepath",
        grammar: [
            G("Pluperfect -mIştI",
              "One action complete before another past point. Form: STEM + -mIş + -tI + PERSON.",
              patterns: [
                P("Example",
                  "'He had already come when I arrived.'",
                  ex: [("Ben geldiğimde o çoktan gitmişti.", "When I arrived, he had already gone.")])
              ]),
            G("Past habitual -ArdI / -IrdI",
              "Used to do. Aorist + past. 'I used to go to school here.'",
              patterns: [
                P("Habitual",
                  "",
                  ex: [("Çocukken bu okula giderdim.", "When I was a child, I used to go to this school."),
                       ("Her sabah koşardık.", "We used to run every morning.")])
              ])
        ],
        phrases: [
            Phrase("Eskiden daha çok okurdum.", "I used to read more."),
            Phrase("Biz tanıştığımızda o evlenmişti.", "When we met, he had already got married.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b2-plup-mc1", "'I used to go' =",
                ["gittim", "giderdim", "gitmişim", "gidiyordum"],
                correct: 1
            ))
        ]
    )

    // MARK: 5. Subordination (-DIğI zaman / -mAk için / diye)
    static let lesson05 = L(
        5, "subord",
        titleTR: "Bağımlı Yan Cümleler",
        titleEN: "Subordinate Clauses · Time / Purpose / Reason",
        summary: "Glue complex sentences together with time, purpose, and reason connectors.",
        systemImage: "square.stack.3d.down.right",
        grammar: [
            G("Time: -DIğI zaman / -DIğInda",
              "'When X happens/happened'.",
              patterns: [
                P("Example",
                  "",
                  ex: [("Eve geldiğim zaman yorgundum.", "When I came home I was tired."),
                       ("Yağmur yağdığında şemsiyeni aç.", "When it rains, open your umbrella.")])
              ]),
            G("Purpose: -mAk için / -sIn diye",
              "'In order to' and 'so that'.",
              patterns: [
                P("With infinitive",
                  "Same-subject purpose uses -mAk için",
                  ex: [("Türkçe öğrenmek için Türkiye'ye geldim.", "I came to Turkey to learn Turkish.")]),
                P("With optative + diye",
                  "Different-subject purpose uses -sIn diye",
                  ex: [("Duyasın diye yüksek sesle söyledim.", "I said it loudly so you'd hear.")])
              ]),
            G("Reason: -DIğI için",
              "'Because …'",
              patterns: [
                P("Example",
                  "",
                  ex: [("Hasta olduğu için gelmedi.", "He didn't come because he was sick.")])
              ])
        ],
        phrases: [
            Phrase("Türkçe öğrenmek için geldim.", "I came to learn Turkish."),
            Phrase("Geç kaldığım için özür dilerim.", "I'm sorry for being late.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b2-sub-mc1", "'Because it was raining' =",
                ["yağmur yağdığı için", "yağmur yağıyor", "yağmur yağarsa", "yağmur yağacak"],
                correct: 0
            ))
        ]
    )
}
