import Foundation

// MARK: - A1 Curriculum (CEFR Beginner / Başlangıç)
// Comprehensive A1 Turkish syllabus: 24 lessons covering the essential vocabulary
// (~300 words), core grammar units, and everyday communicative phrases.
// Content aligned with the Common European Framework of Reference A1 descriptors.

enum A1Content {
    static let lessons: [Lesson] = A1Part1.lessons + A1Part2.lessons
}

// Helper to keep line counts sane.
func L(_ number: Int, _ idSuffix: String,
       titleTR: String, titleEN: String,
       summary: String, systemImage: String,
       vocab: [VocabularyItem] = [],
       grammar: [GrammarNote] = [],
       phrases: [Phrase] = [],
       exercises: [Exercise] = []) -> Lesson {
    Lesson(
        id: "a1-\(idSuffix)",
        level: .a1,
        number: number,
        titleTR: titleTR,
        titleEN: titleEN,
        summary: summary,
        systemImage: systemImage,
        vocabulary: vocab,
        grammar: grammar,
        phrases: phrases,
        exercises: exercises
    )
}

enum A1Part1 {
    static let lessons: [Lesson] = [
        lesson01, lesson02, lesson03, lesson04, lesson05, lesson06,
        lesson07, lesson08, lesson09, lesson10, lesson11, lesson12
    ]

    // MARK: 1. Alphabet & Pronunciation
    static let lesson01 = L(
        1, "alphabet",
        titleTR: "Alfabe ve Telaffuz",
        titleEN: "Alphabet & Pronunciation",
        summary: "Learn the 29 letters of the Turkish alphabet and the core pronunciation rules that make Turkish one of the most phonetic languages in the world.",
        systemImage: "textformat",
        vocab: [
            VocabularyItem("harf", "letter"),
            VocabularyItem("ses", "sound"),
            VocabularyItem("sesli harf", "vowel"),
            VocabularyItem("sessiz harf", "consonant"),
            VocabularyItem("kelime", "word"),
            VocabularyItem("cümle", "sentence"),
            VocabularyItem("Türkçe", "Turkish (language)"),
            VocabularyItem("dil", "language / tongue"),
            VocabularyItem("okumak", "to read", .verb),
            VocabularyItem("yazmak", "to write", .verb),
            VocabularyItem("söylemek", "to say / to tell", .verb),
            VocabularyItem("anlamak", "to understand", .verb)
        ],
        grammar: [
            GrammarNote(
                title: "The 29 letters",
                explanation: "Turkish uses a Latin alphabet with 29 letters: A B C Ç D E F G Ğ H I İ J K L M N O Ö P R S Ş T U Ü V Y Z. There are 8 vowels (a, e, ı, i, o, ö, u, ü). There is no Q, W, or X. Every letter represents one sound — spelling follows pronunciation almost perfectly.",
                examples: [
                    Phrase("ç — çay", "ch, as in 'chair' — tea"),
                    Phrase("ş — şeker", "sh, as in 'shell' — sugar"),
                    Phrase("ğ — dağ", "a soft letter that lengthens the previous vowel — mountain"),
                    Phrase("ı — kitap", "an 'uh' sound with unrounded lips — book"),
                    Phrase("ö — göz", "like German ö / French eu — eye"),
                    Phrase("ü — yüz", "like German ü / French u — face / hundred")
                ]
            ),
            GrammarNote(
                title: "Vowel harmony at a glance",
                explanation: "Vowels split into two groups — front (e, i, ö, ü) and back (a, ı, o, u). Most suffixes change form to match the last vowel of the word. You'll meet this rule in every lesson.",
                examples: [
                    Phrase("ev-ler", "houses — front vowel e takes -ler"),
                    Phrase("kitap-lar", "books — back vowel a takes -lar")
                ]
            )
        ],
        phrases: [
            Phrase("Merhaba!", "Hello!"),
            Phrase("Türkçe öğreniyorum.", "I am learning Turkish."),
            Phrase("Bu bir harftir.", "This is a letter.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-alphabet-mc1",
                "Which letter does NOT exist in the Turkish alphabet?",
                ["Ç", "Ş", "W", "Ğ"],
                correct: 2,
                explanation: "Turkish has no Q, W, or X."
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a1-alphabet-mc2",
                "How many vowels does Turkish have?",
                ["5", "6", "7", "8"],
                correct: 3,
                explanation: "Eight: a, e, ı, i, o, ö, u, ü."
            )),
            .flashcard(FlashcardSet(id: "a1-alphabet-fc", cards: [
                VocabularyItem("harf", "letter"),
                VocabularyItem("kelime", "word"),
                VocabularyItem("okumak", "to read", .verb),
                VocabularyItem("yazmak", "to write", .verb)
            ]))
        ]
    )

    // MARK: 2. Greetings & Introductions
    static let lesson02 = L(
        2, "greetings",
        titleTR: "Selamlaşma ve Tanışma",
        titleEN: "Greetings & Introductions",
        summary: "Greet people, introduce yourself, and exchange polite pleasantries in everyday situations.",
        systemImage: "hand.wave.fill",
        vocab: [
            VocabularyItem("merhaba", "hello", .interjection),
            VocabularyItem("selam", "hi", .interjection),
            VocabularyItem("günaydın", "good morning", .phrase),
            VocabularyItem("iyi günler", "good day", .phrase),
            VocabularyItem("iyi akşamlar", "good evening", .phrase),
            VocabularyItem("iyi geceler", "good night", .phrase),
            VocabularyItem("hoşça kal", "goodbye (to the one staying: 'stay well')", .phrase),
            VocabularyItem("güle güle", "goodbye (to the one leaving: 'go smiling')", .phrase),
            VocabularyItem("görüşürüz", "see you", .phrase),
            VocabularyItem("teşekkür ederim", "thank you", .phrase),
            VocabularyItem("rica ederim", "you're welcome", .phrase),
            VocabularyItem("lütfen", "please", .adverb),
            VocabularyItem("adım", "my name"),
            VocabularyItem("ismim", "my name (alt.)"),
            VocabularyItem("memnun oldum", "pleased to meet you", .phrase)
        ],
        grammar: [
            GrammarNote(
                title: "Introducing yourself",
                explanation: "The simplest pattern is 'Benim adım ___' ('My name is ___') or just 'Ben ___' ('I am ___'). Turkish usually drops the subject pronoun; context makes the subject clear.",
                examples: [
                    Phrase("Benim adım Ayşe.", "My name is Ayşe."),
                    Phrase("Ben Ali.", "I'm Ali."),
                    Phrase("Adın ne?", "What is your name? (informal)"),
                    Phrase("Adınız ne?", "What is your name? (formal / plural)")
                ]
            )
        ],
        phrases: [
            Phrase("Merhaba, nasılsın?", "Hello, how are you?"),
            Phrase("İyiyim, teşekkür ederim. Sen nasılsın?", "I'm well, thank you. How are you?"),
            Phrase("Tanıştığımıza memnun oldum.", "Nice to meet you."),
            Phrase("Hoşça kal!", "Goodbye!")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-greet-mc1",
                "Which phrase do you say to the person who is LEAVING?",
                ["Hoşça kal", "Güle güle", "Günaydın", "İyi geceler"],
                correct: 1,
                explanation: "'Güle güle' is said by the one staying to the one leaving."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-greet-fb1",
                "Benim ___ Ali.",
                answer: "adım",
                translation: "My name is Ali.",
                hint: "A word meaning 'my name'."
            )),
            .flashcard(FlashcardSet(id: "a1-greet-fc", cards: [
                VocabularyItem("merhaba", "hello"),
                VocabularyItem("teşekkür ederim", "thank you"),
                VocabularyItem("lütfen", "please"),
                VocabularyItem("iyi geceler", "good night")
            ]))
        ]
    )

    // MARK: 3. Numbers 0-100
    static let lesson03 = L(
        3, "numbers",
        titleTR: "Sayılar: 0–100",
        titleEN: "Numbers: 0–100",
        summary: "Count, tell prices, and exchange phone numbers. Turkish numbers are regular — learn 1–10 and you can build everything up to 100.",
        systemImage: "number",
        vocab: [
            VocabularyItem("sıfır", "zero", .number),
            VocabularyItem("bir", "one", .number),
            VocabularyItem("iki", "two", .number),
            VocabularyItem("üç", "three", .number),
            VocabularyItem("dört", "four", .number),
            VocabularyItem("beş", "five", .number),
            VocabularyItem("altı", "six", .number),
            VocabularyItem("yedi", "seven", .number),
            VocabularyItem("sekiz", "eight", .number),
            VocabularyItem("dokuz", "nine", .number),
            VocabularyItem("on", "ten", .number),
            VocabularyItem("yirmi", "twenty", .number),
            VocabularyItem("otuz", "thirty", .number),
            VocabularyItem("kırk", "forty", .number),
            VocabularyItem("elli", "fifty", .number),
            VocabularyItem("altmış", "sixty", .number),
            VocabularyItem("yetmiş", "seventy", .number),
            VocabularyItem("seksen", "eighty", .number),
            VocabularyItem("doksan", "ninety", .number),
            VocabularyItem("yüz", "hundred", .number)
        ],
        grammar: [
            GrammarNote(
                title: "Building compound numbers",
                explanation: "Just concatenate tens + ones. There is no 'and' between them. Nouns after numbers stay singular: 'iki kitap' (two book) — never 'iki kitaplar'.",
                examples: [
                    Phrase("on bir", "eleven"),
                    Phrase("yirmi beş", "twenty-five"),
                    Phrase("kırk dokuz", "forty-nine"),
                    Phrase("yüz", "one hundred"),
                    Phrase("üç elma", "three apples (lit. three apple)")
                ]
            )
        ],
        phrases: [
            Phrase("Kaç yaşındasın?", "How old are you?"),
            Phrase("Otuz yaşındayım.", "I am thirty years old."),
            Phrase("Telefon numaran kaç?", "What is your phone number?")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-num-mc1", "Which number is 47?",
                ["kırk yedi", "dört yedi", "yedi kırk", "otuz yedi"],
                correct: 0
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-num-fb1", "___ beş = 25",
                answer: "yirmi", translation: "twenty-five"
            )),
            .flashcard(FlashcardSet(id: "a1-num-fc", cards: [
                VocabularyItem("bir", "1", .number),
                VocabularyItem("beş", "5", .number),
                VocabularyItem("on", "10", .number),
                VocabularyItem("yüz", "100", .number)
            ]))
        ]
    )

    // MARK: 4. Days, Months, Seasons
    static let lesson04 = L(
        4, "time-units",
        titleTR: "Günler, Aylar, Mevsimler",
        titleEN: "Days, Months & Seasons",
        summary: "Name the days of the week, months of the year, and the four seasons — essential for dates, appointments, and small talk.",
        systemImage: "calendar",
        vocab: [
            VocabularyItem("gün", "day"),
            VocabularyItem("hafta", "week"),
            VocabularyItem("ay", "month / moon"),
            VocabularyItem("yıl", "year"),
            VocabularyItem("pazartesi", "Monday"),
            VocabularyItem("salı", "Tuesday"),
            VocabularyItem("çarşamba", "Wednesday"),
            VocabularyItem("perşembe", "Thursday"),
            VocabularyItem("cuma", "Friday"),
            VocabularyItem("cumartesi", "Saturday"),
            VocabularyItem("pazar", "Sunday"),
            VocabularyItem("ocak", "January"),
            VocabularyItem("şubat", "February"),
            VocabularyItem("mart", "March"),
            VocabularyItem("nisan", "April"),
            VocabularyItem("mayıs", "May"),
            VocabularyItem("haziran", "June"),
            VocabularyItem("temmuz", "July"),
            VocabularyItem("ağustos", "August"),
            VocabularyItem("eylül", "September"),
            VocabularyItem("ekim", "October"),
            VocabularyItem("kasım", "November"),
            VocabularyItem("aralık", "December"),
            VocabularyItem("ilkbahar", "spring"),
            VocabularyItem("yaz", "summer"),
            VocabularyItem("sonbahar", "autumn"),
            VocabularyItem("kış", "winter")
        ],
        grammar: [
            GrammarNote(
                title: "Dates",
                explanation: "Turkish dates follow day–month–year order. Days of the week and month names are lowercase by default (capitalised only at sentence start).",
                examples: [
                    Phrase("3 Mayıs 2025", "3 May 2025"),
                    Phrase("Bugün pazartesi.", "Today is Monday."),
                    Phrase("Kışın İstanbul soğuktur.", "In winter Istanbul is cold.")
                ]
            )
        ],
        phrases: [
            Phrase("Bugün ne günü?", "What day is it today?"),
            Phrase("Yarın cumartesi.", "Tomorrow is Saturday."),
            Phrase("Doğum günüm haziranda.", "My birthday is in June.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-time-mc1", "Which word means 'Friday'?",
                ["pazartesi", "cuma", "perşembe", "pazar"],
                correct: 1
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a1-time-mc2", "Which season is 'kış'?",
                ["spring", "summer", "autumn", "winter"],
                correct: 3
            ))
        ]
    )

    // MARK: 5. Family
    static let lesson05 = L(
        5, "family",
        titleTR: "Aile",
        titleEN: "Family",
        summary: "Talk about your family, introduce relatives, and describe relationships.",
        systemImage: "person.3.fill",
        vocab: [
            VocabularyItem("aile", "family"),
            VocabularyItem("anne", "mother"),
            VocabularyItem("baba", "father"),
            VocabularyItem("anne baba", "parents", .phrase),
            VocabularyItem("oğul", "son"),
            VocabularyItem("kız", "daughter / girl"),
            VocabularyItem("çocuk", "child"),
            VocabularyItem("kardeş", "sibling"),
            VocabularyItem("abla", "older sister"),
            VocabularyItem("ağabey", "older brother"),
            VocabularyItem("dede", "grandfather"),
            VocabularyItem("nine", "grandmother (maternal)"),
            VocabularyItem("büyükanne", "grandmother"),
            VocabularyItem("büyükbaba", "grandfather (alt.)"),
            VocabularyItem("amca", "uncle (father's brother)"),
            VocabularyItem("hala", "aunt (father's sister)"),
            VocabularyItem("dayı", "uncle (mother's brother)"),
            VocabularyItem("teyze", "aunt (mother's sister)"),
            VocabularyItem("eş", "spouse"),
            VocabularyItem("arkadaş", "friend")
        ],
        grammar: [
            GrammarNote(
                title: "Simple sentences with 'var' / 'yok'",
                explanation: "Use 'var' for 'there is / I have' and 'yok' for the negative. Possession is shown with a possessive suffix on the thing, not a separate verb.",
                examples: [
                    Phrase("Bir kardeşim var.", "I have a sibling."),
                    Phrase("Çocuğum yok.", "I have no child."),
                    Phrase("İki ablam var.", "I have two older sisters.")
                ]
            )
        ],
        phrases: [
            Phrase("Ailen kalabalık mı?", "Is your family big?"),
            Phrase("Annem öğretmen.", "My mother is a teacher."),
            Phrase("Bir erkek kardeşim var.", "I have a brother.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-family-mc1", "Which word means 'older sister'?",
                ["anne", "abla", "teyze", "kız"],
                correct: 1
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-family-fb1", "Benim iki ___ var.",
                answer: "kardeşim", translation: "I have two siblings.")
            ),
            .flashcard(FlashcardSet(id: "a1-family-fc", cards: [
                VocabularyItem("anne", "mother"),
                VocabularyItem("baba", "father"),
                VocabularyItem("kardeş", "sibling"),
                VocabularyItem("arkadaş", "friend")
            ]))
        ]
    )

    // MARK: 6. Colors
    static let lesson06 = L(
        6, "colors",
        titleTR: "Renkler",
        titleEN: "Colors",
        summary: "Describe objects and people with the most common colors in Turkish.",
        systemImage: "paintpalette.fill",
        vocab: [
            VocabularyItem("renk", "color"),
            VocabularyItem("kırmızı", "red", .adjective),
            VocabularyItem("mavi", "blue", .adjective),
            VocabularyItem("sarı", "yellow", .adjective),
            VocabularyItem("yeşil", "green", .adjective),
            VocabularyItem("siyah", "black", .adjective),
            VocabularyItem("beyaz", "white", .adjective),
            VocabularyItem("turuncu", "orange", .adjective),
            VocabularyItem("mor", "purple", .adjective),
            VocabularyItem("pembe", "pink", .adjective),
            VocabularyItem("kahverengi", "brown", .adjective),
            VocabularyItem("gri", "gray", .adjective),
            VocabularyItem("açık", "light", .adjective),
            VocabularyItem("koyu", "dark", .adjective)
        ],
        grammar: [
            GrammarNote(
                title: "Adjective order",
                explanation: "Adjectives come BEFORE the noun and never change form: 'kırmızı elma' = red apple, 'kırmızı elmalar' = red apples. Use 'açık' (light) or 'koyu' (dark) before a color to modify shade.",
                examples: [
                    Phrase("açık mavi gök", "light blue sky"),
                    Phrase("koyu yeşil çim", "dark green grass"),
                    Phrase("kırmızı bir araba", "a red car")
                ]
            )
        ],
        phrases: [
            Phrase("En sevdiğin renk ne?", "What is your favorite color?"),
            Phrase("En sevdiğim renk mavi.", "My favorite color is blue."),
            Phrase("Bu çanta siyah.", "This bag is black.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-col-mc1", "Which color is 'pembe'?",
                ["purple", "pink", "orange", "gray"],
                correct: 1
            )),
            .flashcard(FlashcardSet(id: "a1-col-fc", cards: [
                VocabularyItem("kırmızı", "red", .adjective),
                VocabularyItem("mavi", "blue", .adjective),
                VocabularyItem("beyaz", "white", .adjective),
                VocabularyItem("siyah", "black", .adjective)
            ]))
        ]
    )

    // MARK: 7. Personal Pronouns & 'to be'
    static let lesson07 = L(
        7, "pronouns-tobe",
        titleTR: "Kişi Zamirleri ve 'Olmak'",
        titleEN: "Personal Pronouns & 'To Be'",
        summary: "Learn the six personal pronouns and the copular suffixes that express 'to be' — the heart of every basic sentence.",
        systemImage: "person.crop.circle",
        vocab: [
            VocabularyItem("ben", "I", .pronoun),
            VocabularyItem("sen", "you (informal)", .pronoun),
            VocabularyItem("o", "he / she / it", .pronoun),
            VocabularyItem("biz", "we", .pronoun),
            VocabularyItem("siz", "you (formal / plural)", .pronoun),
            VocabularyItem("onlar", "they", .pronoun),
            VocabularyItem("öğrenci", "student"),
            VocabularyItem("öğretmen", "teacher"),
            VocabularyItem("doktor", "doctor"),
            VocabularyItem("mühendis", "engineer")
        ],
        grammar: [
            GrammarNote(
                title: "Copular suffixes (to be)",
                explanation: "Turkish has no verb 'to be' as a separate word. Instead, short suffixes are added to the predicate: -(y)ım/-(y)im, -sın/-sin, (nothing), -(y)ız/-(y)iz, -sınız/-siniz, -(lar)/-(ler). They follow vowel harmony.",
                examples: [
                    Phrase("Ben öğrenciyim.", "I am a student."),
                    Phrase("Sen öğrencisin.", "You are a student."),
                    Phrase("O öğrenci.", "He/She is a student."),
                    Phrase("Biz öğrenciyiz.", "We are students."),
                    Phrase("Siz öğrencisiniz.", "You (formal) are a student."),
                    Phrase("Onlar öğrenciler.", "They are students.")
                ]
            ),
            GrammarNote(
                title: "Negative: 'değil'",
                explanation: "For 'not', place 'değil' after the predicate and add the copular suffix to 'değil'.",
                examples: [
                    Phrase("Ben doktor değilim.", "I am not a doctor."),
                    Phrase("O öğrenci değil.", "He/She is not a student.")
                ]
            )
        ],
        phrases: [
            Phrase("Sen öğretmen misin?", "Are you a teacher?"),
            Phrase("Evet, ben öğretmenim.", "Yes, I am a teacher."),
            Phrase("Hayır, ben mühendisim.", "No, I am an engineer.")
        ],
        exercises: [
            .fillInBlank(FillInBlankQuestion(
                "a1-tobe-fb1", "Biz öğrenci___.",
                answer: "yiz",
                translation: "We are students.",
                hint: "1st person plural copular suffix after a vowel."
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a1-tobe-mc1",
                "Choose the correct sentence for 'I am a doctor'.",
                ["Ben doktorsun.", "Ben doktorum.", "Ben doktoruz.", "Ben doktor."],
                correct: 1
            ))
        ]
    )

    // MARK: 8. Possessive Suffixes
    static let lesson08 = L(
        8, "possessive",
        titleTR: "İyelik Ekleri",
        titleEN: "Possessive Suffixes",
        summary: "Turkish expresses 'my, your, his/her, our, your, their' with suffixes on the noun. Master these and you'll sound natural in every sentence about family, things and places.",
        systemImage: "hands.sparkles",
        vocab: [
            VocabularyItem("ev", "house"),
            VocabularyItem("kitap", "book"),
            VocabularyItem("kalem", "pen"),
            VocabularyItem("araba", "car"),
            VocabularyItem("telefon", "phone"),
            VocabularyItem("çanta", "bag"),
            VocabularyItem("okul", "school")
        ],
        grammar: [
            GrammarNote(
                title: "Possessive suffix chart",
                explanation: "The suffix attaches directly to the noun. After a vowel, a buffer 'y' or 's' is inserted. Examples below use 'ev' (house) with back vowels and 'kitap' (book).",
                examples: [
                    Phrase("evim", "my house"),
                    Phrase("evin", "your house"),
                    Phrase("evi", "his/her/its house"),
                    Phrase("evimiz", "our house"),
                    Phrase("eviniz", "your (pl/formal) house"),
                    Phrase("evleri", "their house"),
                    Phrase("arabam", "my car"),
                    Phrase("arabası", "his/her car (buffer 's' after vowel)")
                ]
            )
        ],
        phrases: [
            Phrase("Benim kitabım burada.", "My book is here."),
            Phrase("Arabanız çok güzel.", "Your car is very nice."),
            Phrase("Onun adı Mehmet.", "His/Her name is Mehmet.")
        ],
        exercises: [
            .fillInBlank(FillInBlankQuestion(
                "a1-poss-fb1", "Bu benim kitap___.",
                answer: "ım", translation: "This is my book.",
                hint: "1st person singular possessive."
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-poss-fb2", "Onun araba___ kırmızı.",
                answer: "sı", translation: "His/Her car is red.",
                hint: "Buffer 's' needed after the final vowel."
            ))
        ]
    )

    // MARK: 9. Plural -lar / -ler
    static let lesson09 = L(
        9, "plural",
        titleTR: "Çoğul Eki: -lar / -ler",
        titleEN: "Plural Suffix: -lar / -ler",
        summary: "Making plurals in Turkish is simple and regular — choose -lar or -ler according to vowel harmony.",
        systemImage: "rectangle.stack.fill",
        vocab: [
            VocabularyItem("masa", "table"),
            VocabularyItem("sandalye", "chair"),
            VocabularyItem("pencere", "window"),
            VocabularyItem("kapı", "door"),
            VocabularyItem("öğrenci", "student"),
            VocabularyItem("çiçek", "flower"),
            VocabularyItem("hayvan", "animal"),
            VocabularyItem("köpek", "dog"),
            VocabularyItem("kedi", "cat")
        ],
        grammar: [
            GrammarNote(
                title: "Choosing -lar vs -ler",
                explanation: "If the last vowel is a back vowel (a, ı, o, u), use -lar. If it is a front vowel (e, i, ö, ü), use -ler. Numbers REPLACE the plural — say 'iki kitap', never 'iki kitaplar'.",
                examples: [
                    Phrase("masalar", "tables"),
                    Phrase("evler", "houses"),
                    Phrase("kedi → kediler", "cats"),
                    Phrase("araba → arabalar", "cars"),
                    Phrase("beş çocuk", "five children (no -lar)")
                ]
            )
        ],
        phrases: [
            Phrase("Bahçede çiçekler var.", "There are flowers in the garden."),
            Phrase("Öğrenciler sınıfta.", "The students are in the classroom.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-plural-mc1", "Plural of 'kitap' is…",
                ["kitaplar", "kitapler", "kitablar", "kitablır"],
                correct: 0
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-plural-fb1", "İki köpek___ var.",
                answer: "", translation: "There are two dogs.",
                hint: "Numbers + noun: leave it singular."
            ))
        ]
    )

    // MARK: 10. Locative -da / -de
    static let lesson10 = L(
        10, "locative",
        titleTR: "Bulunma Hâli: -da / -de",
        titleEN: "Locative Case: -da / -de",
        summary: "Say where someone or something is using the locative suffix — your first Turkish grammar case.",
        systemImage: "mappin.and.ellipse",
        vocab: [
            VocabularyItem("ev", "house"),
            VocabularyItem("okul", "school"),
            VocabularyItem("bahçe", "garden"),
            VocabularyItem("park", "park"),
            VocabularyItem("şehir", "city"),
            VocabularyItem("İstanbul", "Istanbul"),
            VocabularyItem("Ankara", "Ankara"),
            VocabularyItem("kafe", "café"),
            VocabularyItem("sokak", "street"),
            VocabularyItem("iş", "work / job")
        ],
        grammar: [
            GrammarNote(
                title: "-da / -de / -ta / -te",
                explanation: "Attach to a noun to mean 'in / on / at'. Choose -da/-ta after back vowels, -de/-te after front vowels. After a voiceless consonant (ç, f, h, k, p, s, ş, t), the 'd' hardens to 't'.",
                examples: [
                    Phrase("evde", "at home"),
                    Phrase("okulda", "at school"),
                    Phrase("sokakta", "on the street (voiceless k → -ta)"),
                    Phrase("İstanbul'da", "in Istanbul"),
                    Phrase("Ahmet'te", "at Ahmet's (proper noun → apostrophe + -te)")
                ]
            )
        ],
        phrases: [
            Phrase("Neredesin?", "Where are you?"),
            Phrase("Ofisteyim.", "I am at the office."),
            Phrase("Kedim bahçede.", "My cat is in the garden.")
        ],
        exercises: [
            .fillInBlank(FillInBlankQuestion(
                "a1-loc-fb1", "Ben şimdi İstanbul'___.",
                answer: "da", translation: "I am in Istanbul now."
            )),
            .multipleChoice(MultipleChoiceQuestion(
                "a1-loc-mc1", "Which is correct?",
                ["okulde", "okulda", "okulta", "okuldi"],
                correct: 1
            ))
        ]
    )

    // MARK: 11. Food & Drink
    static let lesson11 = L(
        11, "food-drink",
        titleTR: "Yiyecek ve İçecek",
        titleEN: "Food & Drink",
        summary: "Essential food and drink vocabulary plus likes and dislikes.",
        systemImage: "fork.knife",
        vocab: [
            VocabularyItem("yemek", "food / meal / to eat", .noun),
            VocabularyItem("su", "water"),
            VocabularyItem("çay", "tea"),
            VocabularyItem("kahve", "coffee"),
            VocabularyItem("süt", "milk"),
            VocabularyItem("ekmek", "bread"),
            VocabularyItem("peynir", "cheese"),
            VocabularyItem("yumurta", "egg"),
            VocabularyItem("et", "meat"),
            VocabularyItem("tavuk", "chicken"),
            VocabularyItem("balık", "fish"),
            VocabularyItem("sebze", "vegetable"),
            VocabularyItem("meyve", "fruit"),
            VocabularyItem("elma", "apple"),
            VocabularyItem("portakal", "orange"),
            VocabularyItem("domates", "tomato"),
            VocabularyItem("salata", "salad"),
            VocabularyItem("çorba", "soup"),
            VocabularyItem("tatlı", "dessert / sweet", .noun),
            VocabularyItem("şeker", "sugar")
        ],
        grammar: [
            GrammarNote(
                title: "'Sevmek' — to like",
                explanation: "Use the accusative case on the object you like. Add -yor for present continuous: 'seviyorum' = I love/like. The thing you like takes the accusative suffix -(y)ı/-(y)i/-(y)u/-(y)ü.",
                examples: [
                    Phrase("Çayı seviyorum.", "I like tea."),
                    Phrase("Kahveyi sevmiyorum.", "I don't like coffee."),
                    Phrase("Sen balık sever misin?", "Do you like fish?")
                ]
            )
        ],
        phrases: [
            Phrase("Ne içmek istersin?", "What would you like to drink?"),
            Phrase("Bir çay lütfen.", "One tea, please."),
            Phrase("Afiyet olsun!", "Enjoy your meal!"),
            Phrase("Çok lezzetli.", "Very delicious.")
        ],
        exercises: [
            .flashcard(FlashcardSet(id: "a1-food-fc", cards: [
                VocabularyItem("su", "water"),
                VocabularyItem("çay", "tea"),
                VocabularyItem("ekmek", "bread"),
                VocabularyItem("elma", "apple"),
                VocabularyItem("peynir", "cheese")
            ])),
            .multipleChoice(MultipleChoiceQuestion(
                "a1-food-mc1", "'Tavuk' means…",
                ["fish", "chicken", "meat", "egg"],
                correct: 1
            ))
        ]
    )

    // MARK: 12. Ordering at a Café
    static let lesson12 = L(
        12, "cafe",
        titleTR: "Kafede Sipariş",
        titleEN: "Ordering at a Café",
        summary: "Survive and thrive in a Turkish café — order drinks, ask for the bill, and be polite.",
        systemImage: "cup.and.saucer.fill",
        vocab: [
            VocabularyItem("garson", "waiter"),
            VocabularyItem("menü", "menu"),
            VocabularyItem("sipariş", "order"),
            VocabularyItem("hesap", "the bill"),
            VocabularyItem("para", "money"),
            VocabularyItem("fiyat", "price"),
            VocabularyItem("ucuz", "cheap", .adjective),
            VocabularyItem("pahalı", "expensive", .adjective),
            VocabularyItem("masa", "table"),
            VocabularyItem("kaşık", "spoon"),
            VocabularyItem("çatal", "fork"),
            VocabularyItem("bıçak", "knife"),
            VocabularyItem("bardak", "glass"),
            VocabularyItem("fincan", "cup")
        ],
        grammar: [
            GrammarNote(
                title: "Polite requests with 'rica ederim / lütfen'",
                explanation: "To be polite, end a request with 'lütfen' or add 'rica ederim'. Use 'alabilir miyim?' ('may I have…?') for an extra-courteous ask.",
                examples: [
                    Phrase("Bir çay lütfen.", "One tea, please."),
                    Phrase("Hesabı alabilir miyim?", "May I have the bill?"),
                    Phrase("Menüyü görebilir miyim?", "May I see the menu?")
                ]
            )
        ],
        phrases: [
            Phrase("Hoş geldiniz!", "Welcome!"),
            Phrase("Ne alırsınız?", "What would you like?"),
            Phrase("Bir Türk kahvesi, şekerli lütfen.", "One Turkish coffee, with sugar please."),
            Phrase("Hesap lütfen.", "The bill, please."),
            Phrase("Üstü kalsın.", "Keep the change.")
        ],
        exercises: [
            .multipleChoice(MultipleChoiceQuestion(
                "a1-cafe-mc1", "How do you politely ask for the bill?",
                ["Para!", "Hesap lütfen.", "Menü var mı?", "Ne kadar?"],
                correct: 1
            )),
            .fillInBlank(FillInBlankQuestion(
                "a1-cafe-fb1", "Bir çay ___.",
                answer: "lütfen", translation: "One tea, please."
            ))
        ]
    )
}
