import Foundation

// Lessons 13-24 of the A1 curriculum.
enum A1Part2 {
    static let lessons: [Lesson] = [
        lesson13, lesson14, lesson15, lesson16, lesson17, lesson18,
        lesson19, lesson20, lesson21, lesson22, lesson23, lesson24
    ]

    // MARK: 13. Home & Rooms
    static let lesson13 = L(
        13, "home",
        titleTR: "Ev ve Odalar",
        titleEN: "Home & Rooms",
        summary: "Describe where you live — rooms, furniture, and everyday household objects.",
        systemImage: "house.fill",
        vocab: [
            VocabularyItem("oda", "room"),
            VocabularyItem("salon", "living room"),
            VocabularyItem("mutfak", "kitchen"),
            VocabularyItem("banyo", "bathroom"),
            VocabularyItem("tuvalet", "toilet"),
            VocabularyItem("yatak odası", "bedroom", .phrase),
            VocabularyItem("balkon", "balcony"),
            VocabularyItem("pencere", "window"),
            VocabularyItem("kapı", "door"),
            VocabularyItem("yatak", "bed"),
            VocabularyItem("masa", "table"),
            VocabularyItem("sandalye", "chair"),
            VocabularyItem("buzdolabı", "refrigerator"),
            VocabularyItem("televizyon", "television"),
            VocabularyItem("bilgisayar", "computer")
        ],
        grammar: [
            GrammarNote(
                title: "'var' / 'yok' with locations",
                explanation: "Combine with the locative to say 'there is … in …' or 'there isn't …'.",
                examples: [
                    Phrase("Mutfakta buzdolabı var.", "There is a fridge in the kitchen."),
                    Phrase("Odamda televizyon yok.", "There is no TV in my room.")
                ]
            )
        ],
        phrases: [
            Phrase("Evim küçük ama çok rahat.", "My home is small but very comfortable."),
            Phrase("Kaç odanız var?", "How many rooms do you have?")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-home-mc1", "'Mutfak' means…",
                ["bedroom", "kitchen", "bathroom", "balcony"],
                correct: 1
            )),
            // Writing quiz: locative + 'var' / 'yok'.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-home-wq1",
                "Write 'There is no TV in my room.' in Turkish. Which is correct?",
                ["Odamda televizyon yok.", "Odamda televizyon de\u011fil.", "Oda televizyon yok.", "Odamda televizyonum yok."],
                correct: 0,
                explanation: "To say 'there is no X in Y', use 'Y-LOC X yok'. The possessive goes on the location, not the thing.",
                rationales: [
                    "Correct. 'oda+m+da' = 'in my room' + 'televizyon yok' = '(there is) no TV'.",
                    "'de\u011fil' negates copulas ('is not'), not existence. Use 'yok' for 'there isn\u2019t'.",
                    "Missing the possessive: 'oda' = 'room' (generic); 'odam' = 'my room'. And the locative -da is missing.",
                    "Double-marked: 'televizyonum' adds a second possessive. Say 'odamda televizyon yok' (no TV in my room), not 'my TV'."
                ]
            ))
        ]
    )

    // MARK: 14. Daily Routine
    static let lesson14 = L(
        14, "routine",
        titleTR: "Günlük Rutin",
        titleEN: "Daily Routine",
        summary: "Describe a typical day using the most common everyday verbs.",
        systemImage: "sun.and.horizon.fill",
        vocab: [
            VocabularyItem("kalkmak", "to get up", .verb),
            VocabularyItem("uyumak", "to sleep", .verb),
            VocabularyItem("yemek yemek", "to eat (a meal)", .verb),
            VocabularyItem("içmek", "to drink", .verb),
            VocabularyItem("çalışmak", "to work / to study", .verb),
            VocabularyItem("okumak", "to read", .verb),
            VocabularyItem("yazmak", "to write", .verb),
            VocabularyItem("gitmek", "to go", .verb),
            VocabularyItem("gelmek", "to come", .verb),
            VocabularyItem("dinlemek", "to listen", .verb),
            VocabularyItem("izlemek", "to watch", .verb),
            VocabularyItem("konuşmak", "to speak", .verb),
            VocabularyItem("sabah", "morning"),
            VocabularyItem("öğle", "noon"),
            VocabularyItem("akşam", "evening"),
            VocabularyItem("gece", "night")
        ],
        grammar: [
            GrammarNote(
                title: "Infinitive → verb stem",
                explanation: "Remove -mek / -mak from the dictionary form to get the stem. 'gitmek' → 'git-'. You then add tense and person suffixes to the stem.",
                examples: [
                    Phrase("gitmek → git-", "to go → go-"),
                    Phrase("çalışmak → çalış-", "to work → work-"),
                    Phrase("okumak → oku-", "to read → read-")
                ]
            )
        ],
        phrases: [
            Phrase("Sabah saat yedide kalkarım.", "I get up at seven in the morning."),
            Phrase("Akşam kitap okurum.", "In the evening I read a book.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a1-routine-fc", cards: [
                VocabularyItem("kalkmak", "to get up", .verb),
                VocabularyItem("gitmek", "to go", .verb),
                VocabularyItem("okumak", "to read", .verb),
                VocabularyItem("uyumak", "to sleep", .verb)
            ])),
            // Writing quiz: infinitive → stem derivation.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-routine-wq1",
                "Which is the correct verb STEM of '\u00e7al\u0131\u015fmak'?",
                ["\u00e7al\u0131\u015f-", "\u00e7al\u0131\u015fma-", "\u00e7al\u0131\u015fm-", "\u00e7al\u0131\u015fmak-"],
                correct: 0,
                explanation: "To get the stem, drop '-mek' or '-mak' from the dictionary form. '\u00e7al\u0131\u015f-' is the bare stem you attach tense + person suffixes to.",
                rationales: [
                    "Correct. Drop -mak \u2192 \u00e7al\u0131\u015f-. You then attach -\u0131yor-, -d\u0131-, -acak-, etc.",
                    "Drop the whole infinitive ending (-mak), not just -k.",
                    "Only -mek / -mak is dropped. Keep everything up to the last vowel of the stem.",
                    "The dictionary form is never the stem. You always strip the infinitive suffix first."
                ]
            ))
        ]
    )

    // MARK: 15. Present Continuous -iyor
    static let lesson15 = L(
        15, "present-continuous",
        titleTR: "Şimdiki Zaman: -iyor",
        titleEN: "Present Continuous: -iyor",
        summary: "Talk about what is happening right now and about your general habits using the versatile -iyor tense.",
        systemImage: "clock.fill",
        vocab: [
            VocabularyItem("şimdi", "now", .adverb),
            VocabularyItem("bugün", "today", .adverb),
            VocabularyItem("her gün", "every day", .phrase),
            VocabularyItem("her zaman", "always", .phrase),
            VocabularyItem("bazen", "sometimes", .adverb),
            VocabularyItem("hiç", "never / ever", .adverb)
        ],
        grammar: [
            GrammarNote(
                title: "Forming -(I)yor",
                explanation: "Drop -mek/-mak, add -(I)yor, then the personal suffix. Use I as shorthand for ı/i/u/ü chosen by vowel harmony. Final vowels are replaced by the -iyor vowel: 'okumak → okuyor'.",
                examples: [
                    Phrase("Geliyorum.", "I am coming."),
                    Phrase("Çalışıyorsun.", "You are working."),
                    Phrase("Türkçe öğreniyor.", "He/She is learning Turkish."),
                    Phrase("Film izliyoruz.", "We are watching a film."),
                    Phrase("Ne yapıyorsunuz?", "What are you (pl.) doing?"),
                    Phrase("Kitap okuyorlar.", "They are reading a book.")
                ]
            ),
            GrammarNote(
                title: "Negative and question",
                explanation: "Negative: insert -mI- before -yor: gel-mi-yor-um (I am not coming). Question: separate '-mi/-mı/-mu/-mü' particle with personal suffix: 'geliyor musun?' (are you coming?)",
                examples: [
                    Phrase("Türkçe konuşmuyorum.", "I am not speaking Turkish."),
                    Phrase("Çay içiyor musun?", "Are you drinking tea?")
                ]
            )
        ],
        phrases: [
            Phrase("Ne yapıyorsun?", "What are you doing?"),
            Phrase("Kitap okuyorum.", "I am reading a book."),
            Phrase("Müzik dinliyor musun?", "Are you listening to music?")
        ],
        exercises: [
            .fillInBlank(FillInBlankQuestion(
                "a1-pc-fb1", "Ben Türkçe öğren___.",
                answer: "iyorum", translation: "I am learning Turkish."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-pc-fb2", "Sen ne yap___?",
                answer: "ıyorsun", translation: "What are you doing?"
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a1-pc-mc1",
                "Correct negative of 'geliyorum':",
                ["gelmiyorum", "gelmuyorum", "gelmeyorum", "geliyormuyum"],
                correct: 0
            )),
            // Writing quiz: full present-continuous conjugation, 1S.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-pc-wq1",
                "Write 'I am reading a book.' in Turkish. Which is correct?",
                ["Kitap okuyorum.", "Kitap\u0131 okuyorum.", "Kitab\u0131 oku\u0131yorum.", "Kitap okiyorum."],
                correct: 0,
                explanation: "Turkish drops a stem-final vowel before -(I)yor (oku + -yor = okuyor). With a generic object, no accusative is needed. 1S suffix is -um.",
                rationales: [
                    "Correct. 'oku-' + 'yor' + 'um' = 'okuyorum'. Object stays indefinite.",
                    "Accusative makes the book definite ('the book'). Only use it when referring to a specific book.",
                    "Buffer vowel error: a stem ending in a vowel drops it, so 'oku-' + '-yor' \u2192 'okuyor', not 'oku\u0131yor'.",
                    "Wrong harmony: after 'oku' the vowel before -yor elides; then 1S needs -um (round back), not -iyorum."
                ]
            ))
        ]
    )

    // MARK: 16. Telling the Time
    static let lesson16 = L(
        16, "time-of-day",
        titleTR: "Saat",
        titleEN: "Telling the Time",
        summary: "Ask the time and say when things happen — a must for appointments, travel, and daily routines.",
        systemImage: "alarm.fill",
        vocab: [
            VocabularyItem("saat", "hour / clock / o'clock"),
            VocabularyItem("dakika", "minute"),
            VocabularyItem("buçuk", "half past"),
            VocabularyItem("çeyrek", "quarter"),
            VocabularyItem("sabah", "morning"),
            VocabularyItem("öğleden sonra", "afternoon", .phrase),
            VocabularyItem("şu an", "at the moment", .phrase)
        ],
        grammar: [
            GrammarNote(
                title: "Telling the time",
                explanation: "For whole hours: 'Saat + NUMBER'. Half past: 'Saat NUMBER buçuk'. Quarter past / to: use 'çeyrek geçiyor / var'. For minutes past (0–30) → '… geçiyor'; to (30–60) → '… var'.",
                examples: [
                    Phrase("Saat kaç?", "What time is it?"),
                    Phrase("Saat üç.", "It's three o'clock."),
                    Phrase("Saat üç buçuk.", "It's half past three."),
                    Phrase("Saat dörde çeyrek var.", "It's a quarter to four."),
                    Phrase("Saat beşi on geçiyor.", "It's ten past five.")
                ]
            )
        ],
        phrases: [
            Phrase("Toplantı saat kaçta?", "What time is the meeting?"),
            Phrase("Saat sekizde görüşelim.", "Let's meet at eight.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-time2-mc1", "'Half past seven' in Turkish is…",
                ["Saat yedi çeyrek", "Saat yedi buçuk", "Saat yedi on beş", "Saat yedi otuz"],
                correct: 1
            )),
            // Writing quiz: 'at' a time → locative on the hour.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-time2-wq1",
                "Write 'Let\u2019s meet at eight.' in Turkish. Which is correct?",
                ["Saat sekizde g\u00f6r\u00fc\u015felim.", "Saat sekiz g\u00f6r\u00fc\u015felim.", "Saat sekize g\u00f6r\u00fc\u015felim.", "Saat sekizden g\u00f6r\u00fc\u015felim."],
                correct: 0,
                explanation: "'At TIME' uses the locative -da/-de on the hour number. 'Sekiz' ends in a back vowel 'i'? No \u2014 'i' is front \u2192 -de.",
                rationales: [
                    "Correct. 'sekiz' + front-vowel locative -de \u2192 'sekizde' = 'at eight'.",
                    "Missing the case: bare 'saat sekiz' just names the hour, it doesn\u2019t mean 'at eight'.",
                    "'Sekize' is dative ('to eight'), used for 'quarter to', not 'at eight'.",
                    "'Sekizden' is ablative ('from eight'), not 'at'."
                ]
            ))
        ]
    )

    // MARK: 17. Weather
    static let lesson17 = L(
        17, "weather",
        titleTR: "Hava Durumu",
        titleEN: "Weather",
        summary: "Describe the weather — perfect small-talk topic in Turkey.",
        systemImage: "cloud.sun.fill",
        vocab: [
            VocabularyItem("hava", "weather / air"),
            VocabularyItem("güneş", "sun"),
            VocabularyItem("güneşli", "sunny", .adjective),
            VocabularyItem("bulut", "cloud"),
            VocabularyItem("bulutlu", "cloudy", .adjective),
            VocabularyItem("yağmur", "rain"),
            VocabularyItem("yağmurlu", "rainy", .adjective),
            VocabularyItem("kar", "snow"),
            VocabularyItem("karlı", "snowy", .adjective),
            VocabularyItem("rüzgar", "wind"),
            VocabularyItem("rüzgarlı", "windy", .adjective),
            VocabularyItem("sıcak", "hot", .adjective),
            VocabularyItem("soğuk", "cold", .adjective),
            VocabularyItem("ılık", "warm", .adjective),
            VocabularyItem("serin", "cool", .adjective)
        ],
        grammar: [
            GrammarNote(
                title: "'Hava …' sentences",
                explanation: "Use 'Hava' + adjective as a full sentence. No verb needed.",
                examples: [
                    Phrase("Hava güneşli.", "The weather is sunny."),
                    Phrase("Bugün hava çok sıcak.", "Today the weather is very hot."),
                    Phrase("Yarın yağmur yağacak.", "It will rain tomorrow.")
                ]
            )
        ],
        phrases: [
            Phrase("Bugün hava nasıl?", "How is the weather today?"),
            Phrase("Çok güzel bir gün.", "It's a very nice day.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-weather-mc1", "'Kar yağıyor' means…",
                ["It is sunny.", "It is raining.", "It is snowing.", "It is windy."],
                correct: 2
            )),
            // Writing quiz: descriptive weather sentence.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-weather-wq1",
                "Write 'Today the weather is very hot.' in Turkish. Which is correct?",
                ["Bug\u00fcn hava \u00e7ok s\u0131cak.", "Bug\u00fcn hava \u00e7ok s\u0131cakt\u0131r.", "Bug\u00fcn s\u0131cak hava \u00e7ok.", "Bug\u00fcn \u00e7ok s\u0131cak havada."],
                correct: 0,
                explanation: "'Hava' + intensifier + adjective is the standard pattern. No verb needed; '-d\u0131r' is too formal for small talk.",
                rationales: [
                    "Correct. Natural spoken form.",
                    "Grammatical but over-formal. '-d\u0131r' reads like a news bulletin, not conversation.",
                    "Wrong word order. 'Hava' must come BEFORE the adjective.",
                    "'Havada' means 'in the air / on air' (locative). Not appropriate for 'the weather'."
                ]
            ))
        ]
    )

    // MARK: 18. Shopping & Prices
    static let lesson18 = L(
        18, "shopping",
        titleTR: "Alışveriş",
        titleEN: "Shopping & Prices",
        summary: "Buy things at a market or shop — ask prices, compare, and pay.",
        systemImage: "cart.fill",
        vocab: [
            VocabularyItem("dükkan", "shop"),
            VocabularyItem("market", "market"),
            VocabularyItem("pazar", "bazaar / Sunday"),
            VocabularyItem("fiyat", "price"),
            VocabularyItem("indirim", "discount"),
            VocabularyItem("lira", "lira"),
            VocabularyItem("kuruş", "kuruş (1/100 lira)"),
            VocabularyItem("almak", "to take / to buy", .verb),
            VocabularyItem("satmak", "to sell", .verb),
            VocabularyItem("ödemek", "to pay", .verb),
            VocabularyItem("bakmak", "to look", .verb)
        ],
        grammar: [
            GrammarNote(
                title: "Asking the price",
                explanation: "'Ne kadar?' = 'how much?' — the most useful question in any shop. Answer with the number + 'lira'.",
                examples: [
                    Phrase("Bu ne kadar?", "How much is this?"),
                    Phrase("Otuz lira.", "30 lira."),
                    Phrase("İndirim var mı?", "Is there a discount?")
                ]
            )
        ],
        phrases: [
            Phrase("Bakıyorum, teşekkürler.", "I'm just looking, thanks."),
            Phrase("Çok pahalı!", "Very expensive!"),
            Phrase("Biraz indirim yapar mısınız?", "Could you give a small discount?")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-shop-mc1", "Which asks 'How much?'",
                ["Kaç kişi?", "Ne kadar?", "Nereden?", "Neden?"],
                correct: 1
            )),
            // Writing quiz: polite discount request, informal tone.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-shop-wq1",
                "Write 'Could you give a small discount?' politely in Turkish. Which is best?",
                ["Biraz indirim yapar m\u0131s\u0131n\u0131z?", "Biraz indirim yapar m\u0131s\u0131n?", "\u0130ndirim yap!", "\u0130ndirim m\u0131 yaparsiniz?"],
                correct: 0,
                explanation: "'-Ar m\u0131s\u0131n\u0131z?' is the courteous aorist question directed at 'you-formal/plural'. 'Biraz' softens the request further.",
                rationales: [
                    "Correct. 2P question with aorist + 'biraz' = polite customer tone.",
                    "Grammatical but informal (2S). Using 'sen' with a shopkeeper you don\u2019t know is rude.",
                    "Imperative \u2018yap!\u2019 is a command. Never use this with a shopkeeper.",
                    "Spelling: 'yaparsiniz' should be 'yapars\u0131n\u0131z' (back-vowel harmony)."
                ]
            ))
        ]
    )

    // MARK: 19. Directions & Places
    static let lesson19 = L(
        19, "directions",
        titleTR: "Yön ve Yerler",
        titleEN: "Directions & Places",
        summary: "Ask for and give simple directions in a Turkish town.",
        systemImage: "map.fill",
        vocab: [
            VocabularyItem("sağ", "right", .noun),
            VocabularyItem("sol", "left", .noun),
            VocabularyItem("düz", "straight", .adjective),
            VocabularyItem("ileri", "forward", .adverb),
            VocabularyItem("geri", "back / backwards", .adverb),
            VocabularyItem("yakın", "near", .adjective),
            VocabularyItem("uzak", "far", .adjective),
            VocabularyItem("karşı", "opposite / across"),
            VocabularyItem("yanında", "next to", .preposition),
            VocabularyItem("arkasında", "behind", .preposition),
            VocabularyItem("önünde", "in front of", .preposition),
            VocabularyItem("hastane", "hospital"),
            VocabularyItem("eczane", "pharmacy"),
            VocabularyItem("postane", "post office"),
            VocabularyItem("banka", "bank"),
            VocabularyItem("durak", "stop (bus/tram)"),
            VocabularyItem("istasyon", "station")
        ],
        grammar: [
            GrammarNote(
                title: "Directive case -a / -e",
                explanation: "The dative case marks direction ('to ___'). -a after back vowels, -e after front vowels. After a vowel, add a buffer 'y'.",
                examples: [
                    Phrase("eve", "to the house"),
                    Phrase("okula", "to school"),
                    Phrase("İstanbul'a", "to Istanbul"),
                    Phrase("kafeye", "to the café (buffer y)")
                ]
            )
        ],
        phrases: [
            Phrase("Affedersiniz, eczane nerede?", "Excuse me, where is the pharmacy?"),
            Phrase("Düz git, sonra sağa dön.", "Go straight, then turn right."),
            Phrase("Buraya nasıl gidebilirim?", "How can I get here?")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-dir-mc1", "'Turn left' is…",
                ["Sağa dön.", "Sola dön.", "Düz git.", "Geri dön."],
                correct: 1
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-dir-fb1", "Okul___ gidiyorum.",
                answer: "a", translation: "I am going to school."
            )),
            // Writing quiz: dative with proper-noun apostrophe.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-dir-wq1",
                "Write 'I am going to Istanbul.' in Turkish. Which is correct?",
                ["\u0130stanbul'a gidiyorum.", "\u0130stanbula gidiyorum.", "\u0130stanbul'e gidiyorum.", "\u0130stanbul gidiyorum."],
                correct: 0,
                explanation: "Direction uses the dative -a/-e. 'Istanbul' ends in a back vowel 'u' \u2192 -a. Proper nouns get an apostrophe before any suffix.",
                rationales: [
                    "Correct. '\u0130stanbul' + apostrophe + dative -a.",
                    "Missing apostrophe: proper nouns always take one before a case suffix in standard written Turkish.",
                    "Wrong harmony. Last vowel is 'u' (back), so the dative is -a, not -e.",
                    "Missing the dative entirely. Without -a the sentence reads 'I am going Istanbul', not 'to Istanbul'."
                ]
            ))
        ]
    )

    // MARK: 20. Transportation
    static let lesson20 = L(
        20, "transport",
        titleTR: "Ulaşım",
        titleEN: "Transportation",
        summary: "Navigate buses, trams, ferries and taxis — essential vocabulary for getting around.",
        systemImage: "tram.fill",
        vocab: [
            VocabularyItem("otobüs", "bus"),
            VocabularyItem("tramvay", "tram"),
            VocabularyItem("metro", "metro"),
            VocabularyItem("taksi", "taxi"),
            VocabularyItem("vapur", "ferry"),
            VocabularyItem("tren", "train"),
            VocabularyItem("uçak", "airplane"),
            VocabularyItem("bisiklet", "bicycle"),
            VocabularyItem("araba", "car"),
            VocabularyItem("bilet", "ticket"),
            VocabularyItem("istasyon", "station"),
            VocabularyItem("havaalanı", "airport"),
            VocabularyItem("iskele", "pier / dock")
        ],
        grammar: [
            GrammarNote(
                title: "'ile' — by / with",
                explanation: "'ile' expresses the means of transport ('by …'). Often attached as -(y)le/-la/-le suffix.",
                examples: [
                    Phrase("otobüsle", "by bus"),
                    Phrase("trenle", "by train"),
                    Phrase("arkadaşımla", "with my friend")
                ]
            )
        ],
        phrases: [
            Phrase("Havaalanına otobüsle gidiyorum.", "I'm going to the airport by bus."),
            Phrase("Bir bilet, lütfen.", "One ticket, please.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a1-trans-fc", cards: [
                VocabularyItem("otobüs", "bus"),
                VocabularyItem("tren", "train"),
                VocabularyItem("uçak", "airplane"),
                VocabularyItem("vapur", "ferry")
            ])),
            // Writing quiz: instrumental 'ile' as a suffix.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-trans-wq1",
                "Write 'I am going by bus.' in Turkish. Which is correct?",
                ["Otob\u00fcsle gidiyorum.", "Otob\u00fcsla gidiyorum.", "Otob\u00fcsile gidiyorum.", "Otob\u00fcs ile gidiyorum."],
                correct: 0,
                explanation: "The instrumental is -(y)le / -(y)la, chosen by vowel harmony on the last vowel of the stem. 'Otob\u00fcs' ends in 'u' (back-rounded) but the modern spoken form uses -le after 'ü/i/e', which is why 'otob\u00fcsle' is the accepted form. The long form 'ile' also works as a separate word.",
                rationales: [
                    "Correct. Most natural: the suffix form -le is standard after front-rounded stems.",
                    "Wrong harmony: last-audible vowel is 'u' but modern Turkish matches the nearer front vowel, giving -le not -la.",
                    "Missing buffer: attached forms drop the 'i' of 'ile'. Write it either as -le / -la OR as a separate word ('otob\u00fcs ile'), never 'ile' glued on.",
                    "Grammatical as two words. Considered more formal/literary; the clitic form '-le' is more common in speech."
                ]
            ))
        ]
    )

    // MARK: 21. Body & Health
    static let lesson21 = L(
        21, "body-health",
        titleTR: "Vücut ve Sağlık",
        titleEN: "Body & Health",
        summary: "Name body parts and handle basic health situations.",
        systemImage: "heart.fill",
        vocab: [
            VocabularyItem("vücut", "body"),
            VocabularyItem("baş", "head"),
            VocabularyItem("saç", "hair"),
            VocabularyItem("göz", "eye"),
            VocabularyItem("kulak", "ear"),
            VocabularyItem("burun", "nose"),
            VocabularyItem("ağız", "mouth"),
            VocabularyItem("diş", "tooth"),
            VocabularyItem("boyun", "neck"),
            VocabularyItem("el", "hand"),
            VocabularyItem("parmak", "finger"),
            VocabularyItem("kol", "arm"),
            VocabularyItem("bacak", "leg"),
            VocabularyItem("ayak", "foot"),
            VocabularyItem("karın", "stomach"),
            VocabularyItem("hasta", "sick / patient", .adjective),
            VocabularyItem("sağlık", "health"),
            VocabularyItem("ilaç", "medicine"),
            VocabularyItem("ağrı", "pain")
        ],
        grammar: [
            GrammarNote(
                title: "'Ağrıyor' — it hurts",
                explanation: "To say something hurts, put the body part with possessive suffix + 'ağrıyor'.",
                examples: [
                    Phrase("Başım ağrıyor.", "My head hurts."),
                    Phrase("Karnım ağrıyor.", "My stomach hurts.")
                ]
            )
        ],
        phrases: [
            Phrase("Hastayım.", "I am sick."),
            Phrase("Doktora gitmeliyim.", "I need to go to the doctor.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-body-mc1", "'Göz' means…",
                ["ear", "eye", "hand", "nose"],
                correct: 1
            )),
            // Writing quiz: possessive on body part + a\u011fr\u0131yor.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-body-wq1",
                "Write 'My head hurts.' in Turkish. Which is correct?",
                ["Ba\u015f\u0131m a\u011fr\u0131yor.", "Ba\u015fum a\u011fr\u0131yor.", "Benim ba\u015f a\u011fr\u0131yor.", "Ba\u015f\u0131m a\u011fr\u0131r."],
                correct: 0,
                explanation: "Attach the 1SG possessive to the body part, then use the present-continuous 'a\u011fr\u0131yor' ('is hurting'). No separate 'my'.",
                rationales: [
                    "Correct. 'ba\u015f' + 1SG -\u0131m \u2192 'ba\u015f\u0131m' = 'my head'. Then 'a\u011fr\u0131yor'.",
                    "Wrong harmony: after back-unrounded 'a' the 1SG vowel is '\u0131', not 'u'.",
                    "Turkish doesn\u2019t use 'benim' with a bare noun here; the possessive must be on the noun.",
                    "Grammatical (aorist) but describes a habit ('my head (generally) hurts'). For 'my head hurts NOW' use -\u0131yor."
                ]
            ))
        ]
    )

    // MARK: 22. Clothes
    static let lesson22 = L(
        22, "clothes",
        titleTR: "Giysiler",
        titleEN: "Clothes",
        summary: "Talk about what you wear — everyday clothing and accessories.",
        systemImage: "tshirt.fill",
        vocab: [
            VocabularyItem("tişört", "t-shirt"),
            VocabularyItem("gömlek", "shirt"),
            VocabularyItem("pantolon", "trousers"),
            VocabularyItem("etek", "skirt"),
            VocabularyItem("elbise", "dress"),
            VocabularyItem("ceket", "jacket"),
            VocabularyItem("palto", "coat"),
            VocabularyItem("ayakkabı", "shoes"),
            VocabularyItem("çorap", "socks"),
            VocabularyItem("şapka", "hat"),
            VocabularyItem("eşofman", "tracksuit"),
            VocabularyItem("giymek", "to wear / put on", .verb)
        ],
        phrases: [
            Phrase("Bu gömlek çok güzel.", "This shirt is very nice."),
            Phrase("Bu ayakkabıyı deneyebilir miyim?", "May I try on these shoes?")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a1-clothes-fc", cards: [
                VocabularyItem("gömlek", "shirt"),
                VocabularyItem("ayakkabı", "shoes"),
                VocabularyItem("ceket", "jacket"),
                VocabularyItem("şapka", "hat")
            ])),
            // Writing quiz: permission with -Ebilir + question particle.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-clothes-wq1",
                "Write 'May I try on these shoes?' in Turkish. Which is correct?",
                ["Bu ayakkab\u0131y\u0131 deneyebilir miyim?", "Bu ayakkab\u0131 deneyebilir miyim?", "Bu ayakkab\u0131y\u0131 denerim?", "Bu ayakkab\u0131y\u0131 deneyebilirim mi?"],
                correct: 0,
                explanation: "Definite direct object \u2192 accusative (-y\u0131 after a vowel stem). Ability = stem + -Ebil-. Question = separate 'miyim' with 1SG.",
                rationales: [
                    "Correct. 'ayakkab\u0131' + -y\u0131 (ACC) + 'deneyebilir' + 'miyim'.",
                    "Missing accusative. Shoes are definite ('these shoes'), so you need -y\u0131.",
                    "Aorist 'denerim' means 'I (generally) try'. Not a request for permission.",
                    "Wrong question placement. The particle follows the verb root, then takes the personal suffix: 'deneyebilir miyim?'"
                ]
            ))
        ]
    )

    // MARK: 23. Hobbies & Free Time
    static let lesson23 = L(
        23, "hobbies",
        titleTR: "Hobiler ve Boş Zaman",
        titleEN: "Hobbies & Free Time",
        summary: "Talk about what you love doing in your free time.",
        systemImage: "gamecontroller.fill",
        vocab: [
            VocabularyItem("hobi", "hobby"),
            VocabularyItem("spor", "sport"),
            VocabularyItem("futbol", "football / soccer"),
            VocabularyItem("basketbol", "basketball"),
            VocabularyItem("yüzmek", "to swim", .verb),
            VocabularyItem("koşmak", "to run", .verb),
            VocabularyItem("dans etmek", "to dance", .verb),
            VocabularyItem("şarkı söylemek", "to sing", .verb),
            VocabularyItem("resim yapmak", "to paint / draw", .verb),
            VocabularyItem("yemek yapmak", "to cook", .verb),
            VocabularyItem("oyun", "game"),
            VocabularyItem("film", "movie"),
            VocabularyItem("kitap", "book"),
            VocabularyItem("müzik", "music")
        ],
        grammar: [
            GrammarNote(
                title: "'Hoşuma gidiyor' — I enjoy it",
                explanation: "A natural way to say 'I like' is '… hoşuma gidiyor' — literally 'it goes to my liking'. The thing you enjoy is the subject.",
                examples: [
                    Phrase("Müzik hoşuma gidiyor.", "I like music."),
                    Phrase("Bu film hoşuma gitti.", "I liked this film.")
                ]
            )
        ],
        phrases: [
            Phrase("Hobin ne?", "What is your hobby?"),
            Phrase("Kitap okumayı seviyorum.", "I love reading.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-hob-mc1", "'Yüzmek' means…",
                ["to run", "to swim", "to sing", "to paint"],
                correct: 1
            )),
            // Writing quiz: nominalised object + 'seviyorum'.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-hob-wq1",
                "Write 'I love reading books.' in Turkish. Which is correct?",
                ["Kitap okumay\u0131 seviyorum.", "Kitap okumak seviyorum.", "Kitap oku seviyorum.", "Kitap\u0131 okumay\u0131 seviyorum."],
                correct: 0,
                explanation: "'Sevmek' takes an accusative-marked object. Turn 'to read' into a noun with -mA (okuma) and then accusative -y\u0131: 'okumay\u0131'.",
                rationales: [
                    "Correct. 'okuma' (the act of reading) + -y\u0131 (ACC) + 'seviyorum'.",
                    "Infinitive 'okumak' can\u2019t take a case suffix directly. Nominalise with -mA first.",
                    "Bare stem \u2018oku\u2019 is not a noun. You must nominalise before using it as an object.",
                    "Double accusative. Inside 'kitap okuma' the object 'kitap' stays unmarked (generic reading, not a specific book)."
                ]
            ))
        ]
    )

    // MARK: 24. Basic Questions & Question Suffix -mi
    static let lesson24 = L(
        24, "questions",
        titleTR: "Sorular ve Soru Eki -mi",
        titleEN: "Basic Questions & -mI",
        summary: "Master the question words and the magical little particle 'mi' that turns any statement into a yes/no question.",
        systemImage: "questionmark.circle.fill",
        vocab: [
            VocabularyItem("ne", "what", .pronoun),
            VocabularyItem("kim", "who", .pronoun),
            VocabularyItem("nerede", "where", .pronoun),
            VocabularyItem("ne zaman", "when", .phrase),
            VocabularyItem("niçin", "why", .adverb),
            VocabularyItem("neden", "why (alt.)", .adverb),
            VocabularyItem("nasıl", "how", .adverb),
            VocabularyItem("kaç", "how many / how much", .adjective),
            VocabularyItem("hangi", "which", .adjective),
            VocabularyItem("evet", "yes"),
            VocabularyItem("hayır", "no")
        ],
        grammar: [
            GrammarNote(
                title: "The question particle -mI",
                explanation: "Write 'mi / mı / mu / mü' as a SEPARATE word right after the element you're questioning. It follows vowel harmony and takes the personal suffix.",
                examples: [
                    Phrase("Öğrenci misin?", "Are you a student?"),
                    Phrase("Türk müsün?", "Are you Turkish?"),
                    Phrase("Bu kitap senin mi?", "Is this book yours?"),
                    Phrase("Çay içiyor musunuz?", "Do you (pl.) drink tea?")
                ]
            ),
            GrammarNote(
                title: "Wh-questions",
                explanation: "Turkish wh-questions don't move to the front — the question word sits where the answer would appear.",
                examples: [
                    Phrase("Adın ne?", "What is your name?"),
                    Phrase("Nerede yaşıyorsun?", "Where do you live?"),
                    Phrase("Ne zaman geliyor?", "When is she/he coming?")
                ]
            )
        ],
        phrases: [
            Phrase("Bu kim?", "Who is this?"),
            Phrase("Ne zaman görüşürüz?", "When shall we meet?"),
            Phrase("Seviyor musun?", "Do you like it?")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-q-mc1",
                "Choose the correct question: 'Are you a teacher?'",
                ["Öğretmen misin?", "Öğretmensin mi?", "Sen mi öğretmen?", "Öğretmen miydi?"],
                correct: 0
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-q-fb1", "Sen Türk ___sün?",
                answer: "mü", translation: "Are you Turkish?",
                hint: "Front-rounded vowel harmony."
            )),
            // Writing quiz: wh-question in situ.
            .multipleChoice(MultipleChoiceQuestion(
                "a1-q-wq1",
                "Write 'Where do you live?' in Turkish. Which is correct?",
                ["Nerede ya\u015f\u0131yorsun?", "Nereye ya\u015f\u0131yorsun?", "Sen ya\u015f\u0131yorsun nerede?", "Nerede ya\u015fan?"],
                correct: 0,
                explanation: "Live-in = locative. 'Nerede' ('where, at which place') precedes the verb, and '-s\u0131yorsun' is the 2SG present-continuous.",
                rationales: [
                    "Correct. Wh-word sits where the answer would; verb carries 2SG -sun.",
                    "'Nereye' is the dative ('to where'), used for motion, not residence.",
                    "Wh-words in Turkish stay in the same slot as the answer, not at the end.",
                    "Bare 'ya\u015fan' is not a valid Turkish verb form."
                ]
            ))
        ]
    )
}
