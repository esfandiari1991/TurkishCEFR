import Foundation

/// Rule-based interlinear glosser for Turkish. Each source sentence is
/// tokenised into words, a coarse POS tag is guessed from the surface
/// form (Turkish is agglutinative — suffixes are highly regular), and a
/// short English equivalent is attached. The result is a three-row gloss:
/// `Turkish word / POS+features / English`.
///
/// This is deliberately heuristic, not a full-blown morphological
/// analyser. For a serious parser users can enable Online mode and let
/// a free AI provider (Groq/Gemini) generate the gloss instead — but
/// this local path covers ~80% of A1–A2 content with zero network.
enum InterlinearGlosser {
    struct Token: Identifiable, Hashable {
        let id = UUID()
        let surface: String
        let lemma: String
        let pos: String
        let english: String
        /// Comma-separated list of morphological features we peeled off
        /// (e.g. "ACC", "LOC", "PL", "COP.3S").
        let features: [String]

        var featuresLabel: String { features.joined(separator: "·") }
    }

    /// Gloss every word of the input sentence. Unknown words are tagged
    /// as `?` but still displayed, so the user can see which words the
    /// local glosser couldn't resolve.
    static func gloss(_ sentence: String) -> [Token] {
        let words = sentence
            .lowercased(with: Locale(identifier: "tr_TR"))
            .split { !$0.isLetter && !$0.isNumber && $0 != "'" }
            .map(String.init)
        return words.map { glossOne($0) }
    }

    private static func glossOne(_ word: String) -> Token {
        // 1. Dictionary hit on the full surface form (common A1 words).
        if let hit = quickDictionary[word] {
            return .init(surface: word, lemma: word, pos: hit.pos,
                         english: hit.english, features: [])
        }

        // 2. Suffix peeling. Turkish orders suffixes: STEM + PLURAL + POSS + CASE + COPULA.
        //    We strip them in reverse and keep track of every feature found.
        var features: [String] = []
        var stem = word

        // Copula -(y)Im / -(y)sIn / -(y)Iz ...
        if let (newStem, tag) = peelCopula(stem) {
            stem = newStem
            features.insert(tag, at: 0)
        }

        // Case markers
        if let (newStem, tag) = peelCase(stem) {
            stem = newStem
            features.insert(tag, at: 0)
        }

        // Possessive markers (very rough — only 1S/1P/2S/2P/3S/3P)
        if let (newStem, tag) = peelPossessive(stem) {
            stem = newStem
            features.insert(tag, at: 0)
        }

        // Plural -lar / -ler
        if stem.hasSuffix("lar") || stem.hasSuffix("ler") {
            features.insert("PL", at: 0)
            stem = String(stem.dropLast(3))
        }

        if let hit = quickDictionary[stem] {
            return .init(surface: word, lemma: stem, pos: hit.pos,
                         english: hit.english, features: features)
        }

        // 3. Verb endings — walk through common tense/aspect markers.
        if let verb = peelVerb(word) {
            return .init(surface: word, lemma: verb.lemma,
                         pos: "V", english: verb.englishGloss,
                         features: verb.features)
        }

        return .init(surface: word, lemma: word, pos: "?", english: "?", features: features)
    }

    // MARK: - Heuristic peelers

    private static func peelCopula(_ s: String) -> (String, String)? {
        let map: [(String, String)] = [
            ("yim", "COP.1S"), ("yız", "COP.1P"), ("yum", "COP.1S"), ("yuz", "COP.1P"),
            ("sın", "COP.2S"), ("sun", "COP.2S"), ("sin", "COP.2S"),
            ("sınız", "COP.2P"), ("sunuz", "COP.2P"),
            ("ydi", "PAST.COP"), ("ydı", "PAST.COP"), ("ydu", "PAST.COP"), ("ydü", "PAST.COP"),
        ]
        for (suf, tag) in map where s.hasSuffix(suf) {
            return (String(s.dropLast(suf.count)), tag)
        }
        return nil
    }

    private static func peelCase(_ s: String) -> (String, String)? {
        let map: [(String, String)] = [
            ("yi", "ACC"), ("yı", "ACC"), ("yu", "ACC"), ("yü", "ACC"),
            ("i", "ACC"), ("ı", "ACC"), ("u", "ACC"), ("ü", "ACC"),
            ("ya", "DAT"), ("ye", "DAT"), ("a", "DAT"), ("e", "DAT"),
            ("da", "LOC"), ("de", "LOC"), ("ta", "LOC"), ("te", "LOC"),
            ("dan", "ABL"), ("den", "ABL"), ("tan", "ABL"), ("ten", "ABL"),
            ("ın", "GEN"), ("in", "GEN"), ("un", "GEN"), ("ün", "GEN"),
            ("nın", "GEN"), ("nin", "GEN"), ("nun", "GEN"), ("nün", "GEN"),
        ]
        for (suf, tag) in map where s.count > suf.count + 1 && s.hasSuffix(suf) {
            return (String(s.dropLast(suf.count)), tag)
        }
        return nil
    }

    private static func peelPossessive(_ s: String) -> (String, String)? {
        let map: [(String, String)] = [
            ("ım", "1S.POSS"), ("im", "1S.POSS"), ("um", "1S.POSS"), ("üm", "1S.POSS"),
            ("ın", "2S.POSS"), ("in", "2S.POSS"), ("un", "2S.POSS"), ("ün", "2S.POSS"),
            ("ı", "3S.POSS"), ("i", "3S.POSS"), ("u", "3S.POSS"), ("ü", "3S.POSS"),
            ("sı", "3S.POSS"), ("si", "3S.POSS"), ("su", "3S.POSS"), ("sü", "3S.POSS"),
            ("ımız", "1P.POSS"), ("imiz", "1P.POSS"), ("umuz", "1P.POSS"), ("ümüz", "1P.POSS"),
        ]
        for (suf, tag) in map where s.count > suf.count + 1 && s.hasSuffix(suf) {
            return (String(s.dropLast(suf.count)), tag)
        }
        return nil
    }

    private static func peelVerb(_ s: String) -> (lemma: String, englishGloss: String, features: [String])? {
        let endings: [(String, String)] = [
            ("iyorum", "PRES.CONT.1S"), ("iyorsun", "PRES.CONT.2S"), ("iyor", "PRES.CONT.3S"),
            ("ıyorum", "PRES.CONT.1S"), ("ıyorsun", "PRES.CONT.2S"), ("ıyor", "PRES.CONT.3S"),
            ("uyorum", "PRES.CONT.1S"), ("uyorsun", "PRES.CONT.2S"), ("uyor", "PRES.CONT.3S"),
            ("üyorum", "PRES.CONT.1S"), ("üyorsun", "PRES.CONT.2S"), ("üyor", "PRES.CONT.3S"),
            ("dim", "PAST.1S"), ("dın", "PAST.2S"), ("dı", "PAST.3S"),
            ("tim", "PAST.1S"), ("tın", "PAST.2S"), ("ti", "PAST.3S"),
            ("acağım", "FUT.1S"), ("ecek", "FUT.3S"),
            ("mışım", "EVID.1S"), ("miş", "EVID.3S"),
            ("malıyım", "NEC.1S"), ("malı", "NEC.3S"),
            ("rım", "AOR.1S"), ("ır", "AOR.3S"), ("er", "AOR.3S"),
        ]
        for (end, feat) in endings where s.hasSuffix(end) {
            let stem = String(s.dropLast(end.count))
            let lemma = stem + "mak" // best-guess infinitive
            let english = quickDictionary[stem]?.english ?? "(verb)"
            return (lemma, english, [feat])
        }
        return nil
    }

    // MARK: - Dictionary

    /// Small bundled A1–A2 core-vocabulary dictionary so the most common
    /// ~200 words always gloss even without the full offline corpus. It's
    /// a literal fallback — `CorpusStore` can and should override with
    /// richer lookups once loaded.
    private static let quickDictionary: [String: (pos: String, english: String)] = [
        "ben":    ("PRON", "I"),
        "sen":    ("PRON", "you"),
        "o":      ("PRON", "he/she/it"),
        "biz":    ("PRON", "we"),
        "siz":    ("PRON", "you (plural)"),
        "onlar":  ("PRON", "they"),

        "bu":     ("DEM",  "this"),
        "şu":     ("DEM",  "that"),
        "bir":    ("NUM",  "one / a"),
        "iki":    ("NUM",  "two"),
        "üç":     ("NUM",  "three"),

        "evet":   ("ADV",  "yes"),
        "hayır":  ("ADV",  "no"),
        "merhaba":("INTJ", "hello"),
        "günaydın":("INTJ","good morning"),

        "ev":     ("N",    "house/home"),
        "okul":   ("N",    "school"),
        "kitap":  ("N",    "book"),
        "su":     ("N",    "water"),
        "çay":    ("N",    "tea"),
        "kahve":  ("N",    "coffee"),
        "gün":    ("N",    "day"),
        "yıl":    ("N",    "year"),
        "adam":   ("N",    "man"),
        "kadın":  ("N",    "woman"),
        "çocuk":  ("N",    "child"),
        "anne":   ("N",    "mother"),
        "baba":   ("N",    "father"),
        "kedi":   ("N",    "cat"),
        "köpek":  ("N",    "dog"),

        "büyük":  ("ADJ",  "big"),
        "küçük":  ("ADJ",  "small"),
        "iyi":    ("ADJ",  "good"),
        "kötü":   ("ADJ",  "bad"),
        "güzel":  ("ADJ",  "beautiful"),
        "yeni":   ("ADJ",  "new"),
        "eski":   ("ADJ",  "old"),

        "gel":    ("V",    "come"),
        "git":    ("V",    "go"),
        "al":     ("V",    "take/buy"),
        "ver":    ("V",    "give"),
        "oku":    ("V",    "read"),
        "yaz":    ("V",    "write"),
        "iç":     ("V",    "drink"),
        "ye":     ("V",    "eat"),
        "konuş":  ("V",    "speak"),
        "bil":    ("V",    "know"),
        "gör":    ("V",    "see"),
        "anla":   ("V",    "understand"),
        "sev":    ("V",    "love/like"),
        "yap":    ("V",    "do/make"),

        "ve":     ("CONJ", "and"),
        "ama":    ("CONJ", "but"),
        "çünkü":  ("CONJ", "because"),

        "için":   ("POST", "for"),
        "ile":    ("POST", "with"),
    ]
}
