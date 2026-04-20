import Foundation

// MARK: - A2 Curriculum (CEFR Elementary)
// 8 lessons covering the major A2 milestones: past/future tenses, necessity,
// the full case system (accusative, dative, ablative, genitive), compound
// sentences with conjunctions, and travel/shopping functional language.

enum A2Content {
    static let lessons: [Lesson] = [
        lesson01, lesson02, lesson03, lesson04,
        lesson05, lesson06, lesson07, lesson08
    ]

    /// Helper to keep each lesson compact.
    private static func L(_ n: Int, _ suffix: String,
                          titleTR: String, titleEN: String,
                          summary: String, systemImage: String,
                          vocab: [VocabularyItem] = [],
                          grammar: [GrammarNote] = [],
                          phrases: [Phrase] = [],
                          exercises: [Exercise] = []) -> Lesson {
        Lesson(id: "a2-\(suffix)", level: .a2, number: n,
               titleTR: titleTR, titleEN: titleEN, summary: summary,
               systemImage: systemImage,
               vocabulary: vocab, grammar: grammar,
               phrases: phrases, exercises: exercises)
    }

    // MARK: 1. Simple past (-DI) — finished events
    static let lesson01 = L(
        1, "past-di",
        titleTR: "Görülen Geçmiş Zaman: -dI",
        titleEN: "Simple Past · Witnessed -DI",
        summary: "Report events you witnessed or did yourself. The -DI past is the workhorse for stories, yesterday's news, and completed actions.",
        systemImage: "arrow.uturn.backward.circle.fill",
        vocab: [
            V("dün", "yesterday", .adverb, ipa: "/dyn/", def: "the day before today",
              ex: [("Dün İstanbul'a gittim.", "Yesterday I went to Istanbul.")],
              syn: ["önceki gün"]),
            V("geçen hafta", "last week", .phrase, def: "the previous calendar week",
              ex: [("Geçen hafta hastaydım.", "I was sick last week.")]),
            V("geçen yıl", "last year", .phrase, def: "the previous calendar year",
              ex: [("Geçen yıl İzmir'e taşındık.", "We moved to İzmir last year.")],
              syn: ["geçen sene"]),
            V("önce", "ago · before", .adverb, ipa: "/øndʒe/",
              def: "marks a point in time earlier than now or than another event",
              ex: [("İki yıl önce İngilizce öğreniyordum.", "Two years ago I was studying English."),
                   ("Yemekten önce ellerini yıka.", "Wash your hands before the meal.")]),
            V("sonra", "after · later", .adverb, ipa: "/sonɾa/",
              def: "marks a point in time later than now or another event",
              ex: [("Bir saat sonra görüşürüz.", "See you in an hour.")],
              ant: ["önce"]),
            V("hatırlamak", "to remember", .verb, ipa: "/hatɯɾlamak/",
              def: "to bring something back to mind",
              ex: [("Seni çok iyi hatırlıyorum.", "I remember you very well.")],
              ant: ["unutmak"]),
            V("unutmak", "to forget", .verb, ipa: "/unutmak/",
              def: "to fail to remember",
              ex: [("Anahtarımı evde unuttum.", "I forgot my key at home.")]),
            V("anlatmak", "to tell · to narrate", .verb,
              def: "to explain or tell a story or situation",
              ex: [("Bana ne olduğunu anlattı.", "He told me what happened.")]),
            V("olmak", "to be · to happen", .verb, ipa: "/olmak/",
              def: "to exist, to become, or to take place",
              ex: [("Dün kaza oldu.", "There was an accident yesterday.")])
        ],
        grammar: [
            G("The -DI past (witnessed past)",
              "The -DI suffix reports events that happened in a completed time frame — usually ones the speaker witnessed or knows for certain.",
              intro: "Use -DI for any finished action with a clear time: yesterday, last year, two hours ago. Do NOT use it for things you only heard about (that's -mIş, at B1).",
              rules: [
                R("Vowel harmony", "-dı / -di / -du / -dü", "chosen by the last vowel of the stem: a/ı → dı, e/i → di, o/u → du, ö/ü → dü"),
                R("After voiceless stems", "-tı / -ti / -tu / -tü", "after p, ç, t, k, f, h, s, ş the d becomes t"),
                R("Personal endings", "-m, -n, ∅, -k, -nız, -lAr", "1sg -m, 2sg -n, 3sg nothing, 1pl -k, 2pl -nIz, 3pl -lAr"),
                R("Full pattern", "STEM + DI + PERSON", "example: gel + di + m → geldim (I came)")
              ],
              patterns: [
                P("Regular verb: gelmek (to come)",
                  "All six persons",
                  ex: [("geldim", "I came"), ("geldin", "you came"),
                       ("geldi", "he/she/it came"), ("geldik", "we came"),
                       ("geldiniz", "you (pl./formal) came"), ("geldiler", "they came")]),
                P("Voiceless stem: gitmek (to go)",
                  "Ending consonant t → DI becomes -ti",
                  ex: [("gittim", "I went"), ("gittin", "you went"),
                       ("gitti", "he/she went"), ("gittik", "we went")]),
                P("Question form",
                  "Add 'mI' particle (with harmony) as a separate word after the verb.",
                  ex: [("Geldi mi?", "Did he come?"),
                       ("Aldın mı?", "Did you buy it?")])
              ],
              ex: [
                ("Dün sinemaya gittim.", "Yesterday I went to the cinema."),
                ("Kahvaltıda ne yediniz?", "What did you (all) have for breakfast?"),
                ("Çok güzel bir film izledik.", "We watched a very nice film.")
              ],
              pitfalls: [
                "Don't double the past: 'geldim' already means 'I came'. Never say 'geldim idi'.",
                "Negation goes BEFORE the tense: gel-me-di-m (I didn't come), not gel-di-me-m.",
                "The 3rd person plural -lAr is optional — 'geldi' can mean 'they came' if context is clear."
              ],
              summary: "Formula: STEM + (-dI/-di/-du/-dü or -tI/-ti/-tu/-tü) + PERSONAL ENDING. Use for any completed action you witnessed."),
            G("Negation in the past",
              "Insert -mA- between stem and tense suffix.",
              rules: [
                R("Pattern", "STEM + mA + DI + PERSON", "negative particle comes first"),
                R("Harmony", "-ma (back) / -me (front)", "matches last stem vowel")
              ],
              ex: [("gelmedim", "I didn't come"),
                   ("Dün çalışmadım.", "I didn't work yesterday."),
                   ("Bunu hiç duymadık.", "We never heard this.")])
        ],
        phrases: [
            Phrase("Dün akşam ne yaptın?", "What did you do last night?"),
            Phrase("Çok yorgunum — erken yattım.", "I'm very tired — I went to bed early."),
            Phrase("Hafta sonu çok eğlendik.", "We had a lot of fun at the weekend."),
            Phrase("Maç kaç kaç bitti?", "What was the final score of the match?")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a2-past-fc1", cards: [
                VocabularyItem("dün", "yesterday", .adverb),
                VocabularyItem("önce", "ago / before", .adverb),
                VocabularyItem("hatırlamak", "to remember", .verb),
                VocabularyItem("unutmak", "to forget", .verb),
                VocabularyItem("anlatmak", "to tell", .verb)
            ])),
            .multipleChoice(MultipleChoiceQuestion(
                "a2-past-mc1",
                "Which form correctly means 'I went'?",
                ["gitdim", "gittim", "gitmem", "gideyim"],
                correct: 1,
                explanation: "Stem git- ends in 't' (voiceless), so -dI becomes -ti. 1sg adds -m → gittim."
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a2-past-mc2",
                "What does 'Dün kitap okumadık' mean?",
                ["We read a book yesterday.",
                 "We didn't read a book yesterday.",
                 "We will read a book tomorrow.",
                 "We are reading a book."],
                correct: 1,
                explanation: "-mA- inserted before -dI makes the past negative. oku-ma-dı-k = 'we didn't read'."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-past-fb1", "Dün Ankara'ya git___.",
                answer: "tim", translation: "Yesterday I went to Ankara.",
                hint: "1sg past of gitmek"
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-past-fb2", "Geçen hafta sinemaya ___ (gitmek, we).",
                answer: "gittik", translation: "Last week we went to the cinema."
            ))
        ]
    )

    // MARK: 2. Future (-AcAK)
    static let lesson02 = L(
        2, "future",
        titleTR: "Gelecek Zaman: -AcAK",
        titleEN: "Future Tense · -(y)AcAK",
        summary: "Talk about plans, predictions, and promises using the -(y)AcAK suffix.",
        systemImage: "arrow.forward.circle.fill",
        vocab: [
            V("yarın", "tomorrow", .adverb, ipa: "/jaˈɾɯn/",
              def: "the day after today",
              ex: [("Yarın erken kalkacağım.", "I'll get up early tomorrow.")]),
            V("gelecek hafta", "next week", .phrase,
              ex: [("Gelecek hafta tatile gideceğiz.", "Next week we'll go on holiday.")]),
            V("gelecek ay", "next month", .phrase),
            V("plan", "plan", .noun, ipa: "/plaːn/",
              def: "an intention or arrangement for the future",
              ex: [("Bu akşam planın var mı?", "Do you have a plan tonight?")],
              etym: "Loan from French 'plan'."),
            V("söz vermek", "to promise", .verb,
              def: "to give one's word to do something",
              ex: [("Sana söz veriyorum.", "I promise you.")]),
            V("belki", "maybe", .adverb,
              def: "expresses possibility",
              ex: [("Belki yarın gelirim.", "Maybe I'll come tomorrow.")]),
            V("kesinlikle", "definitely", .adverb,
              def: "without any doubt",
              ex: [("Kesinlikle katılacağım.", "I'll definitely participate.")],
              syn: ["mutlaka"])
        ],
        grammar: [
            G("Future tense -(y)AcAK",
              "The future suffix -(y)AcAK expresses plans, predictions and commitments.",
              intro: "Insert a buffer 'y' if the stem ends in a vowel. Harmony: -acak after back vowels (a, ı, o, u); -ecek after front vowels (e, i, ö, ü). A final -k softens to -ğ- before a vowel-starting personal ending in 1sg and 1pl.",
              rules: [
                R("Back harmony", "-acak", "after a, ı, o, u"),
                R("Front harmony", "-ecek", "after e, i, ö, ü"),
                R("Buffer -y-", "(-y)acak / (-y)ecek", "inserted after a vowel-final stem"),
                R("k → ğ softening", "-acağ- / -eceğ-", "before -ım, -ız and -ı (1sg, 1pl, 3sg accusative)"),
                R("Personal endings", "-ım -sın ∅ -ız -sınız -lar", "final -k softens to -ğ before -ım / -ız")
              ],
              patterns: [
                P("gelmek (to come)", "Regular e-stem verb",
                  ex: [("geleceğim", "I will come"),
                       ("geleceksin", "you will come"),
                       ("gelecek", "he/she will come"),
                       ("geleceğiz", "we will come"),
                       ("geleceksiniz", "you (pl.) will come"),
                       ("gelecekler", "they will come")]),
                P("okumak (to read) — vowel stem", "Needs the buffer -y-",
                  ex: [("okuyacağım", "I will read"),
                       ("okuyacaksın", "you will read"),
                       ("okuyacak", "he/she will read")]),
                P("Negation", "Insert -mA- before -yAcAK",
                  ex: [("gelmeyeceğim", "I won't come"),
                       ("çalışmayacaksın", "you won't work")]),
                P("Question", "Split the verb before the personal ending: add 'mI' particle",
                  ex: [("Gelecek misin?", "Will you come?"),
                       ("Okuyacak mısınız?", "Will you (pl.) read?")])
              ],
              ex: [
                ("Yarın geleceğim.", "I will come tomorrow."),
                ("Hafta sonu ne yapacaksın?", "What will you do this weekend?"),
                ("Yağmur yağacak.", "It will rain."),
                ("Seni asla unutmayacağım.", "I will never forget you.")
              ],
              pitfalls: [
                "Don't forget the softening k→ğ before 1sg/1pl: 'geleceğim' not 'gelecekim'.",
                "Vowel-stem verbs need the buffer -y-: 'okuyacağım' not 'okuacağım'.",
                "The question particle 'mI' is written separately: 'Gelecek mi?' never 'Gelecekmi?'."
              ],
              summary: "Formula: STEM + (y)AcAK + PERSONAL ENDING, with k→ğ softening before 1sg/1pl.")
        ],
        phrases: [
            Phrase("Yarın ne yapacaksın?", "What will you do tomorrow?"),
            Phrase("Hafta sonu hava güzel olacak.", "The weather will be nice this weekend."),
            Phrase("Söz veriyorum, geleceğim.", "I promise, I'll come."),
            Phrase("Belki gelecek ay taşınacağız.", "Maybe we'll move next month.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a2-fut-fc1", cards: [
                VocabularyItem("yarın", "tomorrow", .adverb),
                VocabularyItem("gelecek hafta", "next week", .phrase),
                VocabularyItem("plan", "plan"),
                VocabularyItem("söz vermek", "to promise", .verb),
                VocabularyItem("belki", "maybe", .adverb)
            ])),
            .multipleChoice(MultipleChoiceQuestion(
                "a2-fut-mc1",
                "Which is the correct 1sg future of 'gelmek'?",
                ["gelecem", "gelecekim", "geleceğim", "gelecağım"],
                correct: 2,
                explanation: "Final k softens to ğ before -im: geleceğim."
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a2-fut-mc2",
                "Translate: 'I won't forget you.'",
                ["Seni unuturum.", "Seni unutmayacağım.", "Seni unutmadım.", "Seni unuttum."],
                correct: 1,
                explanation: "Negation -mA- + future -(y)AcAK → unutmayacağım."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-fut-fb1", "Hafta sonu ne yap___ (2sg future)?",
                answer: "acaksın", translation: "What will you do at the weekend?",
                hint: "yap- (to do) + future + 2sg"
            ))
        ]
    )

    // MARK: 3. Necessity -mAlI
    static let lesson03 = L(
        3, "must",
        titleTR: "Gereklilik Kipi: -mAlI",
        titleEN: "Necessity · must / should -mAlI",
        summary: "Express obligation, advice, and moral musts with -mAlI. Essential for giving suggestions and rules.",
        systemImage: "exclamationmark.shield.fill",
        vocab: [
            V("zorunlu", "compulsory", .adjective),
            V("gerek", "need · necessity", .noun,
              ex: [("Buna gerek yok.", "There's no need for this.")]),
            V("şart", "condition · must", .noun,
              def: "an essential requirement",
              ex: [("Başarılı olmak için çalışmak şart.", "To succeed, one must work.")]),
            V("tavsiye etmek", "to recommend", .verb,
              def: "to suggest something as a course of action",
              ex: [("Sana bu filmi tavsiye ederim.", "I recommend this film to you.")]),
            V("kural", "rule", .noun,
              ex: [("Kurallara uymak zorundasın.", "You have to follow the rules.")])
        ],
        grammar: [
            G("Necessity: -mAlI",
              "-mAlI + personal ending = must/should/ought to. Equivalent to English 'must', 'have to', and sometimes 'should'.",
              intro: "Turkish has one general necessity suffix rather than separate words like 'must' and 'should'. Context and tone disambiguate.",
              rules: [
                R("Harmony", "-malı (back) / -meli (front)", "matches last stem vowel"),
                R("Personal endings", "-yIm -sIn ∅ -yIz -sInIz -lAr", "buffer -y- after vowel-final -malı/-meli"),
                R("Negation", "-mA-mAlI", "insert -mA- before -mAlI: gitmemelisin 'you shouldn't go'")
              ],
              patterns: [
                P("gitmek (to go)",
                  "Full paradigm",
                  ex: [("gitmeliyim", "I must go"),
                       ("gitmelisin", "you must go"),
                       ("gitmeli", "he/she must go"),
                       ("gitmeliyiz", "we must go"),
                       ("gitmelisiniz", "you (pl.) must go"),
                       ("gitmeliler", "they must go")]),
                P("Impersonal 'one must'",
                  "Use the 3rd singular form as a general obligation.",
                  ex: [("Burada sigara içmemeli.", "One shouldn't smoke here."),
                       ("Çok su içmeli.", "One should drink a lot of water.")])
              ],
              ex: [
                ("Daha çok çalışmalıyım.", "I must study more."),
                ("Hastaneye gitmelisin.", "You should go to the hospital."),
                ("Geç kalmamalıyız.", "We shouldn't be late."),
                ("Ne yapmalıyım?", "What should I do?")
              ],
              pitfalls: [
                "Don't combine -mAlI with -mIş — that's a different modal (-mAlIymIş 'apparently must').",
                "For strong external compulsion ('I have to by law'), prefer 'zorunda' (Lesson 4)."
              ],
              summary: "Formula: STEM + -mAlI + PERSONAL ENDING. Use for advice, obligation, and rules.")
        ],
        phrases: [
            Phrase("Ne yapmalıyım?", "What should I do?"),
            Phrase("Daha dikkatli olmalısın.", "You should be more careful."),
            Phrase("Bu filmi mutlaka izlemelisin.", "You must definitely watch this film."),
            Phrase("Geç kalmamalıyız.", "We shouldn't be late.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a2-must-mc1", "Translate: 'We should go now.'",
                ["Şimdi gidiyoruz.", "Şimdi gitmeliyiz.", "Şimdi gittik.", "Şimdi gideceğiz."],
                correct: 1
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-must-fb1", "Sınav için daha çok çalış___. (2sg)",
                answer: "malısın", translation: "You must study more for the exam."
            ))
        ]
    )

    // MARK: 4. Dative, Ablative, Genitive
    static let lesson04 = L(
        4, "cases-dat-abl-gen",
        titleTR: "Yönelme, Ayrılma, İlgi Hâlleri",
        titleEN: "Dative · Ablative · Genitive Cases",
        summary: "Mark direction (to), origin (from), and possession (of) with three essential case suffixes.",
        systemImage: "arrow.triangle.branch",
        vocab: [
            V("yol", "road · way", .noun,
              ex: [("Yol uzun.", "The road is long.")],
              syn: ["güzergâh"]),
            V("memleket", "homeland · hometown", .noun,
              def: "one's native land or hometown",
              ex: [("Memleketim İzmir.", "My hometown is İzmir.")]),
            V("köy", "village", .noun, ant: ["şehir"]),
            V("sınır", "border · limit", .noun),
            V("gelmek", "to come", .verb),
            V("gitmek", "to go", .verb)
        ],
        grammar: [
            G("Dative case -(y)A · 'to / toward'",
              "Marks destination, indirect object (give to), or goal.",
              rules: [
                R("Harmony", "-a / -e", "-a after back vowels, -e after front"),
                R("After vowel", "-ya / -ye", "buffer 'y' inserted")
              ],
              patterns: [
                P("Direction",
                  "okul → okul-a ('to school'), İstanbul → İstanbul'a, ev → ev-e",
                  ex: [("Okula gidiyorum.", "I am going to school."),
                       ("Türkiye'ye geldim.", "I came to Turkey."),
                       ("Ona bir hediye verdim.", "I gave him a gift.")])
              ],
              ex: [("Ne zaman eve geleceksin?", "When will you come home?"),
                   ("Ankara'ya gidiyoruz.", "We are going to Ankara.")]),
            G("Ablative case -DAn · 'from'",
              "Marks origin, material, or the starting point of motion.",
              rules: [
                R("Harmony", "-dan / -den", "back/front"),
                R("Voiceless stem", "-tan / -ten", "after p,ç,t,k,f,h,s,ş")
              ],
              patterns: [
                P("Origin",
                  "İstanbul'dan (from Istanbul), okuldan (from school)",
                  ex: [("Türkiye'den geldim.", "I came from Turkey."),
                       ("Ekmek undan yapılır.", "Bread is made from flour.")])
              ],
              ex: [("Nereden geliyorsun?", "Where are you coming from?"),
                   ("İşten çıkıyorum.", "I'm leaving work.")]),
            G("Genitive case -(n)In · 'of / possessor'",
              "Marks the possessor in a possessive chain (N1's N2).",
              rules: [
                R("Harmony", "-ın / -in / -un / -ün", "four-way i-type harmony"),
                R("After vowel", "-nın / -nin / -nun / -nün", "buffer 'n' inserted"),
                R("Possessive chain", "POSSESSOR-GEN + THING-POSS.3sg", "evin kapısı 'the house's door'")
              ],
              patterns: [
                P("Noun phrase: the teacher's book",
                  "öğretmen-in kitab-ı (öğretmen + -in, kitap + -ı) — note the k→b softening in 'kitap'.",
                  ex: [("öğretmenin kitabı", "the teacher's book"),
                       ("evin kapısı", "the house's door"),
                       ("Ali'nin arabası", "Ali's car")]),
                P("Personal pronouns",
                  "benim 'my', senin 'your', onun 'his/her', bizim 'our', sizin 'your (pl)', onların 'their'",
                  ex: [("benim adım", "my name"),
                       ("onun arabası", "his/her car")])
              ],
              ex: [("Türkiye'nin başkenti Ankara'dır.", "Turkey's capital is Ankara.")],
              pitfalls: [
                "Both halves of the possessive chain are marked: possessor takes genitive AND possessed thing takes possessive suffix.",
                "The buffer 'n' in -nIn after a vowel can be confused with -sI possessive — learn them together."
              ],
              summary: "Dative -(y)A = 'to', Ablative -DAn = 'from', Genitive -(n)In = 'of'. Master these and 80% of Turkish case usage is done.")
        ],
        phrases: [
            Phrase("Nereden geliyorsun? — İzmir'den.", "Where are you from? — From İzmir."),
            Phrase("Bu kitap kimin?", "Whose book is this?"),
            Phrase("Bu, Ali'nin çantası.", "This is Ali's bag.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a2-case-mc1", "Which marks 'to the school'?",
                ["okula", "okuldan", "okulun", "okulda"],
                correct: 0
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a2-case-mc2", "Turkey's capital (Turkey + genitive):",
                ["Türkiye'den", "Türkiye'ye", "Türkiye'nin", "Türkiye'de"],
                correct: 2
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-case-fb1", "Ev___ kapısı kırmızı.",
                answer: "in", translation: "The house's door is red.",
                hint: "genitive of 'ev'"
            ))
        ]
    )

    // MARK: 5. Accusative case
    static let lesson05 = L(
        5, "accusative",
        titleTR: "Belirtme Hâli",
        titleEN: "Accusative Case · Definite Direct Object",
        summary: "Mark specific, known direct objects with -(y)I. Master the subtle 'a book' vs 'the book' distinction.",
        systemImage: "arrow.right.square.fill",
        vocab: [
            V("kitap", "book", .noun),
            V("film", "film", .noun),
            V("arkadaş", "friend", .noun),
            V("görmek", "to see", .verb),
            V("sevmek", "to love · to like", .verb),
            V("beklemek", "to wait for", .verb)
        ],
        grammar: [
            G("Accusative case -(y)I",
              "Mark direct objects that are specific, known, or definite. Unmarked direct objects are generic.",
              intro: "Turkish distinguishes 'I'm reading a book' (any book) from 'I'm reading the book' (a specific one) by marking only the second.",
              rules: [
                R("Harmony", "-ı / -i / -u / -ü", "i-type four-way harmony"),
                R("After vowel", "-yı / -yi / -yu / -yü", "buffer 'y' added"),
                R("Rule of thumb", "Mark if 'the', 'this', 'that', a proper noun, or a pronoun",
                  "also mark if the object is previously mentioned and definite")
              ],
              patterns: [
                P("Generic vs definite",
                  "kitap okuyorum 'I read (a) book' vs kitab-ı okuyorum 'I'm reading the book'",
                  ex: [("Meyve yiyorum.", "I'm eating fruit."),
                       ("Meyveyi yiyorum.", "I'm eating the fruit (specific one)."),
                       ("Ali'yi arıyorum.", "I'm looking for Ali."),
                       ("Seni seviyorum.", "I love you.")]),
                P("Proper nouns always take accusative",
                  "Because they refer to a specific person or place.",
                  ex: [("İstanbul'u çok seviyorum.", "I love İstanbul.")]),
                P("With pronouns",
                  "ben-i, sen-i, on-u, biz-i, siz-i, onlar-ı",
                  ex: [("Beni anlıyor musun?", "Do you understand me?")])
              ],
              ex: [
                ("Bu kitabı okudun mu?", "Have you read this book?"),
                ("Filmi izliyoruz.", "We're watching the film."),
                ("Onu tanımıyorum.", "I don't know him.")
              ],
              pitfalls: [
                "'bir X' (a certain X) also often takes accusative: 'bir kitabı okuyorum' = 'I'm reading a particular book'.",
                "Generic objects NEVER take accusative: 'Ben kitap okuyorum' (I read books) not 'kitabı'."
              ],
              summary: "Mark only definite direct objects. Generic/indefinite objects stay bare.")
        ],
        phrases: [
            Phrase("Bu filmi gördün mü?", "Have you seen this film?"),
            Phrase("Onları evde bekledik.", "We waited for them at home."),
            Phrase("Kitabı bitirdim.", "I finished the book.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a2-acc-mc1", "Which sentence requires accusative on the object?",
                ["Ekmek aldım.", "Bu ekmeği aldım.", "Ekmek yedim.", "Her gün kitap okurum."],
                correct: 1,
                explanation: "The demonstrative 'bu' makes the object specific, so it takes -i."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-acc-fb1", "Ali'___ arıyorum.",
                answer: "yi", translation: "I'm looking for Ali.",
                hint: "Proper noun takes accusative; add buffer 'y' after vowel."
            ))
        ]
    )

    // MARK: 6. Ability / possibility -(y)AbIl
    static let lesson06 = L(
        6, "ability",
        titleTR: "Yeterlik ve Olasılık: -(y)AbIl",
        titleEN: "Ability & Possibility · -(y)AbIl",
        summary: "Express 'can', 'may', 'might' with the compound suffix -(y)AbIl.",
        systemImage: "checkmark.seal.fill",
        vocab: [
            V("belki", "maybe", .adverb),
            V("imkân", "possibility", .noun, etym: "Arabic root 'kāf-n'"),
            V("mümkün", "possible", .adjective, etym: "Arabic loan")
        ],
        grammar: [
            G("Ability with -(y)AbIl",
              "Form: STEM + (y)A + bil + TENSE + PERSON. 'bil-' comes from 'bilmek' (to know), but grammaticalised.",
              intro: "For the negative ability ('cannot'), use -(y)AmA instead (the 'bil-' drops).",
              rules: [
                R("Positive", "-(y)AbIl-", "can"),
                R("Negative", "-(y)AmA-", "cannot"),
                R("Question", "positive + mI", "Gelebilir miyim? 'May I come?'")
              ],
              patterns: [
                P("Present: gelebilir (he can come)",
                  "Usually combined with aorist/present tense",
                  ex: [("Gelebilirim.", "I can come."),
                       ("Gelebilir misin?", "Can you come?")]),
                P("Past: gelebildi (he was able to come)",
                  "Add -DI past after -(y)AbIl",
                  ex: [("Dün gelemedim.", "Yesterday I couldn't come.")]),
                P("Permission",
                  "'May I' also uses -(y)AbIl + question",
                  ex: [("İçeri girebilir miyim?", "May I come in?")])
              ],
              ex: [("Türkçe konuşabiliyorum.", "I can speak Turkish."),
                   ("Bu problemi çözebilir misin?", "Can you solve this problem?"),
                   ("Yağmur yağabilir.", "It might rain.")],
              pitfalls: [
                "'Yapamadım' ≠ 'yapmadım'. The first means 'I couldn't do it'; the second 'I didn't do it'.",
                "Aorist tense is usually used for present ability — -Ir- is added after -(y)AbIl."
              ],
              summary: "Positive ability -(y)AbIl-, negative ability -(y)AmA-. Add any tense suffix on top.")
        ],
        phrases: [
            Phrase("Bana yardım edebilir misin?", "Can you help me?"),
            Phrase("Ben yüzebilirim.", "I can swim."),
            Phrase("Hiçbir şey yapamadım.", "I couldn't do anything.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a2-abil-mc1", "'I cannot come' =",
                ["gelmem", "gelmiyorum", "gelemem", "gelmeyeceğim"],
                correct: 2,
                explanation: "Negative ability = STEM + (y)AmA + person (aorist)."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-abil-fb1", "Bana yardım ede___ misin?",
                answer: "bilir", translation: "Can you help me?",
                hint: "positive ability + aorist"
            ))
        ]
    )

    // MARK: 7. Comparatives and superlatives
    static let lesson07 = L(
        7, "comparatives",
        titleTR: "Karşılaştırma",
        titleEN: "Comparatives & Superlatives",
        summary: "Compare things using 'daha', 'kadar', and 'en'.",
        systemImage: "chart.bar.xaxis",
        vocab: [
            V("daha", "more", .adverb,
              ex: [("daha güzel", "more beautiful")],
              ant: ["az", "daha az"]),
            V("en", "most", .adverb,
              ex: [("en güzel", "most beautiful · the best")]),
            V("kadar", "as … as", .preposition, ipa: "/kaˈdaɾ/"),
            V("gibi", "like", .preposition),
            V("büyük", "big", .adjective, ant: ["küçük"]),
            V("küçük", "small", .adjective)
        ],
        grammar: [
            G("Comparative 'daha'",
              "'daha + ADJECTIVE' = 'more ADJECTIVE'. Compared-to object takes ablative -DAn.",
              rules: [
                R("Comparative pattern", "X, Y-DAn daha ADJ", "X is more ADJ than Y")
              ],
              patterns: [
                P("Example",
                  "Ali, Ayşe'den daha uzun.",
                  ex: [("Ali, Ayşe'den daha uzun.", "Ali is taller than Ayşe."),
                       ("Bu araba diğerinden daha hızlı.", "This car is faster than the other one.")])
              ],
              ex: [("İstanbul, Ankara'dan daha büyük.", "Istanbul is bigger than Ankara.")]),
            G("Superlative 'en'",
              "'en + ADJECTIVE' = 'most ADJECTIVE · the -est'.",
              patterns: [
                P("Example",
                  "Dünyanın en yüksek dağı",
                  ex: [("Dünyanın en yüksek dağı.", "The highest mountain in the world."),
                       ("En sevdiğim yemek.", "My favourite food.")])
              ],
              ex: [("Bu sınıfta en akıllı öğrenci Ali.", "Ali is the smartest student in this class.")]),
            G("'kadar' / 'gibi' — equality and similarity",
              "'X, Y kadar ADJ' = 'X is as ADJ as Y'. 'X, Y gibi' = 'X is like Y'.",
              patterns: [
                P("kadar",
                  "noun + kadar = 'as much as'",
                  ex: [("Sen benim kadar çalışıyorsun.", "You work as much as I do.")]),
                P("gibi",
                  "noun + gibi = 'like'",
                  ex: [("Baban gibi konuşuyorsun.", "You speak like your father.")])
              ])
        ],
        phrases: [
            Phrase("Kim daha uzun?", "Who is taller?"),
            Phrase("En sevdiğin film ne?", "What's your favourite film?"),
            Phrase("Benim kadar çalış.", "Work as much as I do.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a2-comp-mc1", "Translate: 'Istanbul is bigger than Ankara.'",
                ["İstanbul Ankara kadar büyük.",
                 "İstanbul Ankara'dan daha büyük.",
                 "Ankara İstanbul'dan büyük.",
                 "İstanbul en büyük şehir."],
                correct: 1
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-comp-fb1", "Türkiye'nin ___ büyük şehri.",
                answer: "en", translation: "The biggest city of Turkey.",
                hint: "superlative marker"
            ))
        ]
    )

    // MARK: 8. Travel & transport
    static let lesson08 = L(
        8, "travel",
        titleTR: "Seyahat ve Ulaşım",
        titleEN: "Travel & Transport",
        summary: "Book tickets, ask for directions, and navigate airports and bus stations in Turkish.",
        systemImage: "airplane.departure",
        vocab: [
            V("uçak", "plane", .noun, ipa: "/uˈtʃak/"),
            V("tren", "train", .noun),
            V("otobüs", "bus", .noun),
            V("taksi", "taxi", .noun),
            V("bilet", "ticket", .noun,
              ex: [("İki bilet, lütfen.", "Two tickets, please.")]),
            V("gidiş", "departure · outbound", .noun),
            V("dönüş", "return", .noun),
            V("kalkış", "departure (flight)", .noun),
            V("varış", "arrival", .noun),
            V("havalimanı", "airport", .noun),
            V("gar", "railway station", .noun, etym: "French 'gare'"),
            V("otogar", "bus terminal", .noun),
            V("valiz", "suitcase", .noun, syn: ["bavul"]),
            V("rezervasyon", "reservation", .noun, etym: "French 'réservation'")
        ],
        grammar: [
            G("Asking for help in transit",
              "Common question patterns at stations and airports.",
              patterns: [
                P("Time", "Saat kaçta …?",
                  ex: [("Uçak saat kaçta kalkıyor?", "What time does the plane take off?")]),
                P("Platform/gate", "… hangi peron/kapı?",
                  ex: [("İzmir treni hangi peronda?", "Which platform is the İzmir train?")]),
                P("Price", "… ne kadar?",
                  ex: [("Tek yön bilet ne kadar?", "How much is a one-way ticket?")])
              ])
        ],
        phrases: [
            Phrase("Bir bilet, lütfen.", "One ticket, please."),
            Phrase("Gidiş-dönüş mü, tek yön mü?", "Round-trip or one-way?"),
            Phrase("Uçağım saat 6'da kalkıyor.", "My flight takes off at six."),
            Phrase("Valizim kayboldu.", "My luggage is lost."),
            Phrase("En yakın metro istasyonu nerede?", "Where is the nearest metro station?")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a2-travel-fc1", cards: [
                VocabularyItem("uçak", "plane"),
                VocabularyItem("tren", "train"),
                VocabularyItem("bilet", "ticket"),
                VocabularyItem("havalimanı", "airport"),
                VocabularyItem("valiz", "suitcase")
            ])),
            .multipleChoice(MultipleChoiceQuestion(
                "a2-travel-mc1",
                "'Gidiş-dönüş' means…",
                ["one way", "return/round-trip", "first class", "arrival"],
                correct: 1
            )),
            .fillInBlank(FillInBlankQuestion(
                "a2-travel-fb1", "İki kişilik bir ___, lütfen.",
                answer: "rezervasyon", translation: "A reservation for two, please."
            ))
        ]
    )
}
