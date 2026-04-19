import Foundation

// MARK: - B1 Curriculum (CEFR Intermediate)
// 6 lessons covering the reported past, aorist, conditional, subjunctive,
// relative clauses (-(y)An / -DIK), and colloquial register.

enum B1Content {
    static let lessons: [Lesson] = [
        lesson01, lesson02, lesson03, lesson04, lesson05, lesson06
    ]

    private static func L(_ n: Int, _ suffix: String,
                          titleTR: String, titleEN: String,
                          summary: String, systemImage: String,
                          vocab: [VocabularyItem] = [],
                          grammar: [GrammarNote] = [],
                          phrases: [Phrase] = [],
                          exercises: [Exercise] = []) -> Lesson {
        Lesson(id: "b1-\(suffix)", level: .b1, number: n,
               titleTR: titleTR, titleEN: titleEN, summary: summary,
               systemImage: systemImage,
               vocabulary: vocab, grammar: grammar,
               phrases: phrases, exercises: exercises)
    }

    // MARK: 1. Reported past -mIş
    static let lesson01 = L(
        1, "reported-past",
        titleTR: "Öğrenilen Geçmiş Zaman: -mIş",
        titleEN: "Reported · Evidential Past -mIş",
        summary: "Report hearsay, inference, or surprise with -mIş. Crucial for storytelling, gossip, and newly discovered facts.",
        systemImage: "quote.bubble.fill",
        vocab: [
            V("duymak", "to hear", .verb,
              ex: [("Bunu duydun mu?", "Have you heard this?")]),
            V("söylemek", "to say · to tell", .verb),
            V("haber", "news", .noun, syn: ["bildiri"]),
            V("meğer", "apparently · as it turns out", .adverb,
              ex: [("Meğer haklıymışsın!", "As it turned out, you were right!")]),
            V("galiba", "probably", .adverb, def: "expresses guess or uncertainty",
              ex: [("Galiba geç kaldım.", "I think I'm late.")])
        ],
        grammar: [
            G("The -mIş past (reported / inferential)",
              "Reports actions the speaker did not directly witness. English has no grammatical equivalent — use 'apparently', 'it seems', 'I heard that'.",
              intro: "Contrast with -DI (witnessed). 'Gelmiş' = he came (apparently, I heard). 'Geldi' = he came (I saw it).",
              rules: [
                R("Harmony", "-mış / -miş / -muş / -müş", "four-way i-harmony"),
                R("Personal endings", "-ım -sın ∅ -ız -sınız -lar", "z-type personal endings with buffer 'ı/i/u/ü'"),
                R("Negative", "-mA-mIş", "gelmemiş 'apparently he didn't come'"),
                R("Question", "-mIş + mI + person", "gelmiş mi? 'did he come?' (inferred)")
              ],
              patterns: [
                P("gelmek paradigm",
                  "",
                  ex: [("gelmişim", "apparently I came"),
                       ("gelmişsin", "apparently you came"),
                       ("gelmiş", "apparently he/she came"),
                       ("gelmişiz", "apparently we came"),
                       ("gelmişsiniz", "apparently you (pl.) came"),
                       ("gelmişler", "apparently they came")]),
                P("Surprise function",
                  "Used with 'meğer', 'demek ki', or exclamation to show new realization.",
                  ex: [("Sen çok güzel konuşuyormuşsun!", "Oh, you speak so well! (I just realised)"),
                       ("Meğer uyuyormuşum!", "Turns out I was sleeping!")]),
                P("Storytelling",
                  "Classic tales, jokes, and fairy-tales use -mIş throughout.",
                  ex: [("Bir varmış, bir yokmuş…", "Once upon a time… (lit. there was one, there wasn't one)")])
              ],
              ex: [
                ("Ali hastaymış.", "Apparently Ali is sick."),
                ("Sınavı geçmişsin, tebrikler!", "You passed the exam — congratulations! (just learned)"),
                ("Dışarıda kar yağıyormuş.", "Apparently it's snowing outside.")
              ],
              pitfalls: [
                "Don't use -mIş for things you witnessed; that's -DI.",
                "Can combine with -DI for the pluperfect: gelmişti 'he had come'."
              ],
              summary: "Use -mIş for hearsay, inference, surprise, and storytelling.")
        ],
        phrases: [
            Phrase("Duydun mu? Ayşe evlenmiş!", "Did you hear? Apparently Ayşe got married!"),
            Phrase("Meğer yanılmışım.", "Turns out I was wrong."),
            Phrase("Galiba yağmur yağacakmış.", "It seems it's going to rain.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b1-rep-mc1", "Choose the best translation: 'Apparently he went to Istanbul.'",
                ["İstanbul'a gitti.", "İstanbul'a gidecek.", "İstanbul'a gitmiş.", "İstanbul'a gidiyor."],
                correct: 2,
                explanation: "-mIş expresses hearsay."
            )),
            .fillInBlank(FillInBlankQuestion(
                "b1-rep-fb1", "Ayşe yeni bir araba al___ (reported past, 3sg).",
                answer: "mış", translation: "Apparently Ayşe bought a new car."
            ))
        ]
    )

    // MARK: 2. Aorist -(A/I)r
    static let lesson02 = L(
        2, "aorist",
        titleTR: "Geniş Zaman: -(A/I)r",
        titleEN: "Aorist · Habitual & General Truths -(A/I)r",
        summary: "Describe habits, general truths, willingness, and polite requests.",
        systemImage: "arrow.triangle.2.circlepath",
        vocab: [
            V("her zaman", "always", .phrase),
            V("genellikle", "usually", .adverb),
            V("bazen", "sometimes", .adverb),
            V("asla", "never", .adverb, syn: ["hiçbir zaman"]),
            V("çoğu zaman", "often", .phrase)
        ],
        grammar: [
            G("Aorist -(A/I)r",
              "Marks habit, general truths, and willingness. Polite offers and requests also use the aorist.",
              intro: "Aorist is irregular: monosyllabic stems take -Ar, polysyllabic stems take -Ir. ~13 monosyllabic verbs take -Ir instead (see pitfalls).",
              rules: [
                R("Polysyllabic", "-Ir", "(-ır -ir -ur -ür): çalışır, oturur"),
                R("Monosyllabic", "-Ar", "(-ar -er): yapar, gider"),
                R("Irregular -Ir monosyllabic", "-Ir", "al-, bil-, bul-, gel-, gör-, kal-, olur-, ol-, san-, ver-, vur-, dur-, sanır…"),
                R("Negative", "-mAz", "yapmaz 'doesn't do'. 1sg -mam, 1pl -mayız are irregular.")
              ],
              patterns: [
                P("yapmak paradigm",
                  "",
                  ex: [("yaparım", "I (usually) do"),
                       ("yaparsın", "you do"),
                       ("yapar", "he does"),
                       ("yaparız", "we do"),
                       ("yaparsınız", "you (pl.) do"),
                       ("yaparlar", "they do")]),
                P("Negative",
                  "yapmam, yapmazsın, yapmaz, yapmayız, yapmazsınız, yapmazlar",
                  ex: [("Et yemem.", "I don't eat meat."),
                       ("Sigara içmeyiz.", "We don't smoke.")]),
                P("Polite offers and requests",
                  "Aorist is standard for 'would you…?'",
                  ex: [("Çay içer misiniz?", "Would you have tea?"),
                       ("Kapıyı açar mısın?", "Could you open the door?")]),
                P("General truths",
                  "Used for science and facts.",
                  ex: [("Dünya Güneş'in etrafında döner.", "The Earth revolves around the Sun.")])
              ],
              ex: [
                ("Her sabah kahve içerim.", "I drink coffee every morning."),
                ("Sigara içer misiniz?", "Do you smoke?"),
                ("Türkçe konuşur musun?", "Do you speak Turkish?")
              ],
              pitfalls: [
                "Don't confuse aorist with present continuous: 'kahve içerim' (I drink coffee, habit) vs 'kahve içiyorum' (I'm drinking coffee now).",
                "1sg negative is irregular: 'yapmam' (not 'yapmazım')."
              ],
              summary: "Aorist expresses habit, truth, and polite request. Choose -Ar or -Ir based on stem length and irregular list.")
        ],
        phrases: [
            Phrase("Türkçe konuşur musun?", "Do you speak Turkish?"),
            Phrase("Kahvaltıda ne yersin?", "What do you usually have for breakfast?"),
            Phrase("Hiç sigara içmem.", "I never smoke.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b1-aor-mc1", "Which is a habitual statement?",
                ["Kahve içtim.", "Kahve içiyorum.", "Kahve içerim.", "Kahve içeceğim."],
                correct: 2
            )),
            .fillInBlank(FillInBlankQuestion(
                "b1-aor-fb1", "Et ___ (yemek, negative 1sg).",
                answer: "yemem", translation: "I don't eat meat.",
                hint: "irregular aorist negative 1sg"
            ))
        ]
    )

    // MARK: 3. Conditional / hypothetical
    static let lesson03 = L(
        3, "conditional",
        titleTR: "Koşul Kipi: -sA",
        titleEN: "Conditional · -sA",
        summary: "Build if-clauses and express wishes.",
        systemImage: "arrow.triangle.branch",
        vocab: [
            V("eğer", "if", .conjunction, ipa: "/eˈɟeɾ/"),
            V("şayet", "if perhaps", .conjunction),
            V("keşke", "if only · I wish", .interjection,
              ex: [("Keşke burada olsaydın.", "If only you were here.")])
        ],
        grammar: [
            G("Conditional -sA",
              "Turkish uses -sA to build hypothetical and real conditions. 'Eğer' (if) is optional.",
              intro: "Real condition (present/future): STEM + (I)r-sA. Unreal (past): STEM + sA-ydI.",
              rules: [
                R("Real condition", "STEM + sA + PERSON", "yaparsan 'if you do'"),
                R("Unreal condition", "STEM + sA + ydI + PERSON", "yapsaydın 'if you had done'"),
                R("Wishes", "keşke + VERB-sA-ydI", "keşke gitseydim 'I wish I had gone'")
              ],
              patterns: [
                P("Real",
                  "'If it rains, we stay home.'",
                  ex: [("Yağmur yağarsa, evde kalırız.", "If it rains, we'll stay home.")]),
                P("Unreal",
                  "'If I had money…' — counterfactual",
                  ex: [("Param olsaydı, araba alırdım.", "If I had money, I would buy a car.")]),
                P("Wish",
                  "",
                  ex: [("Keşke İstanbul'da yaşasaydım.", "I wish I lived in Istanbul.")])
              ],
              ex: [
                ("Eğer istersen, seninle gelirim.", "If you want, I'll come with you."),
                ("Vaktim olsa, sana yardım ederdim.", "If I had time, I would help you.")
              ],
              summary: "Pair -sA with aorist for real conditions, with -ydI for unreal / past.")
        ],
        phrases: [
            Phrase("Eğer gelirsen, çok sevinirim.", "I'd be very happy if you came."),
            Phrase("Keşke yapabilseydim.", "I wish I could have done it.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b1-cond-mc1", "Translate: 'If I had money, I would travel.'",
                ["Param olursa, seyahat ederim.",
                 "Param olsa, seyahat ederdim.",
                 "Param var, seyahat ediyorum.",
                 "Param olduğu için seyahat ederim."],
                correct: 1
            ))
        ]
    )

    // MARK: 4. Relative clauses with -(y)An
    static let lesson04 = L(
        4, "rel-an",
        titleTR: "Ortaç: -(y)An",
        titleEN: "Subject Relative Clauses · -(y)An",
        summary: "Build 'the person who …' clauses where the relative pronoun is the SUBJECT.",
        systemImage: "text.append",
        vocab: [
            V("adam", "man", .noun),
            V("kadın", "woman", .noun),
            V("kişi", "person", .noun),
            V("öğrenci", "student", .noun),
            V("çalışan", "employee · working", .noun, def: "literally 'one who works' — formed with -An")
        ],
        grammar: [
            G("-(y)An — subject relative",
              "When the noun being described DOES the action of the clause, use -(y)An.",
              intro: "English 'the boy who sleeps' where 'who' = subject. The clause precedes the noun: 'uyuyan çocuk' (sleeping/who-sleeps boy).",
              rules: [
                R("Form", "STEM + (y)An + NOUN", "buffer 'y' after vowel stems"),
                R("Harmony", "-an / -en", "back / front"),
                R("Tense-neutral", "no tense suffix inside", "tense comes from context")
              ],
              patterns: [
                P("Present: a sleeping child",
                  "",
                  ex: [("uyuyan çocuk", "the sleeping child / the child who sleeps"),
                       ("konuşan adam", "the speaking man")]),
                P("Past: the man who came",
                  "-(y)An can refer to past if context is past",
                  ex: [("dün gelen adam", "the man who came yesterday")]),
                P("Negative",
                  "Insert -mA-",
                  ex: [("gelmeyen misafir", "the guest who didn't come")])
              ],
              ex: [
                ("Türkçe öğrenen herkes bu sitede başlasın.", "Everyone learning Turkish should start on this site."),
                ("Orada oturan kadını tanıyor musun?", "Do you know the woman sitting there?")
              ],
              pitfalls: [
                "Use -(y)An only when the noun is the SUBJECT of the relative clause. For object-of-clause, use -DIK (next lesson).",
                "No separate relative pronoun (who, which, that) — the suffix does the job."
              ],
              summary: "SUBJECT of a relative clause → -(y)An + NOUN.")
        ],
        phrases: [
            Phrase("Seni bekleyen biri var.", "There's someone waiting for you."),
            Phrase("Burada oturan kadın annem.", "The woman sitting here is my mother.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b1-rel-mc1", "'The man who came yesterday' =",
                ["dün gelen adam", "dün adam geldi", "dün adam gelmiş", "dünkü gelen adam"],
                correct: 0
            ))
        ]
    )

    // MARK: 5. -DIK relative / factive
    static let lesson05 = L(
        5, "rel-dik",
        titleTR: "Ortaç: -DIK",
        titleEN: "Object Relative & Factive · -DIK",
        summary: "Build 'the X that I did' clauses and 'the fact that …' noun phrases.",
        systemImage: "text.append",
        grammar: [
            G("-DIK relative (object of clause)",
              "Use -DIK when the head noun is NOT the subject of the relative clause — most commonly the object, or a time/place.",
              intro: "Pattern: SUBJECT (genitive) + VERB-DIK-POSS + NOUN. Example: 'The book I read' = 'benim okuduğum kitap'.",
              rules: [
                R("Form", "STEM + DIK + POSSESSIVE", "-DIK takes the possessor of the action as a possessive suffix"),
                R("Harmony", "-dık/-dik/-duk/-dük", "-tık etc. after voiceless stem")
              ],
              patterns: [
                P("Object-of-clause",
                  "the film I watched = izlediğim film (ben-im izle-diğ-im film)",
                  ex: [("dün okuduğum kitap", "the book I read yesterday"),
                       ("sevdiğim şarkı", "the song I love")]),
                P("Factive noun clauses",
                  "'the fact that X' = X-DIK + POSS",
                  ex: [("Geldiğini biliyorum.", "I know that you came."),
                       ("Hasta olduğunu söyledi.", "He said that he was sick.")])
              ],
              ex: [("Sevdiğim şarkıyı çalıyor.", "He's playing the song I love.")],
              pitfalls: [
                "Possessor becomes genitive; the verb takes possessive suffix. 'benim kitabı okuduğum' is wrong — use 'benim okuduğum kitap'.",
                "-DIK clauses can express past OR present — tense is inferred."
              ],
              summary: "For relative clauses where the head noun is NOT the subject, use -DIK + possessive.")
        ],
        phrases: [
            Phrase("Söylediğin doğru.", "What you said is true."),
            Phrase("Sevdiğim film bu.", "This is the film I love.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "b1-dik-mc1", "'The book I read' =",
                ["okuduğum kitap", "okuyan kitap", "okumak kitap", "kitap okudum"],
                correct: 0
            ))
        ]
    )

    // MARK: 6. Colloquial register
    static let lesson06 = L(
        6, "register",
        titleTR: "Günlük Konuşma",
        titleEN: "Colloquial Register & Fillers",
        summary: "Natural conversation markers, fillers, and softeners used in everyday speech.",
        systemImage: "text.bubble.fill",
        vocab: [
            V("yani", "I mean · that is", .particle,
              ex: [("Yani, haklıydın.", "I mean, you were right.")]),
            V("aslında", "actually", .adverb),
            V("bence", "in my opinion", .adverb,
              ex: [("Bence çok güzel.", "I think it's lovely.")]),
            V("şey", "thing · umm", .noun,
              def: "used as a placeholder or filler when searching for a word",
              ex: [("Şey… ne diyordum?", "Umm… what was I saying?")]),
            V("falan filan", "and so on · whatever", .phrase),
            V("tamam mı?", "okay?", .phrase),
            V("hadi", "come on · let's go", .interjection)
        ],
        grammar: [
            G("Softeners and fillers",
              "Natural Turkish speech uses many softening particles. Overusing formal forms sounds robotic.",
              patterns: [
                P("Suggesting",
                  "'hadi' + imperative / 'haydi'",
                  ex: [("Hadi gidelim.", "Come on, let's go.")]),
                P("Softening statements",
                  "'galiba', 'sanırım', 'herhalde'",
                  ex: [("Sanırım geç kaldık.", "I think we're late.")])
              ])
        ],
        phrases: [
            Phrase("Yani, ne diyordun?", "I mean, what were you saying?"),
            Phrase("Bence iyi fikir.", "I think it's a good idea."),
            Phrase("Hadi eve gidelim.", "Come on, let's go home.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "b1-reg-fc", cards: [
                VocabularyItem("yani", "I mean", .particle),
                VocabularyItem("aslında", "actually", .adverb),
                VocabularyItem("bence", "in my opinion", .adverb),
                VocabularyItem("hadi", "come on", .interjection)
            ]))
        ]
    )
}
