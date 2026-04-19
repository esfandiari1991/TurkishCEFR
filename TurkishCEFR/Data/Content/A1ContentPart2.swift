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
            ]))
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
            ]))
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
            ]))
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
            ))
        ]
    )
}
