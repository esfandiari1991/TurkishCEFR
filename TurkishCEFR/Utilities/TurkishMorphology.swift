import Foundation

/// Structural Turkish morphology helpers: vowel harmony, consonant harmony,
/// and verb conjugation across the eight tenses every B1+ learner needs.
///
/// The goal isn't to be a linguistically-complete parser — it's to answer
/// "how do I conjugate X?" for ≈ 95 % of regular Turkish verbs, driven by
/// the rules every textbook ships with. It handles:
///
/// * 4-way (`ı/i/u/ü`) and 2-way (`a/e`) vowel harmony.
/// * Voiced/voiceless consonant harmony for `d/t`.
/// * "y" buffer insertion after vowel stems.
/// * Common irregulars like `gitmek → gid-`, `etmek → ed-` (voicing).
///
/// It does NOT handle suppletive irregulars (`yemek → ye-`, `demek → de-`)
/// beyond the rules above, nor compound verbs like `hissetmek` which need
/// a lexical mapping. We surface these as a short pitfalls list in
/// `ConjugatorView` rather than silently producing wrong forms.
enum TurkishMorphology {
    // MARK: - Harmony rules

    /// Back vowels trigger `ı` or `a`/`u`, front vowels trigger `i`/`e`/`ü`, etc.
    enum VowelClass { case backUnrounded, backRounded, frontUnrounded, frontRounded }

    static let backUnrounded: Set<Character> = ["a", "ı"]
    static let backRounded:   Set<Character> = ["o", "u"]
    static let frontUnrounded: Set<Character> = ["e", "i"]
    static let frontRounded:  Set<Character> = ["ö", "ü"]
    static let allVowels: Set<Character> = backUnrounded.union(backRounded).union(frontUnrounded).union(frontRounded)

    /// The final vowel of the stem decides the harmony class.
    static func lastVowelClass(of word: String) -> VowelClass {
        let lower = word.lowercased(with: Locale(identifier: "tr_TR"))
        for c in lower.reversed() {
            if backUnrounded.contains(c)  { return .backUnrounded }
            if backRounded.contains(c)    { return .backRounded }
            if frontUnrounded.contains(c) { return .frontUnrounded }
            if frontRounded.contains(c)   { return .frontRounded }
        }
        return .frontUnrounded
    }

    /// 4-way harmony vowel: ı / i / u / ü
    static func harmony4(for stem: String) -> Character {
        switch lastVowelClass(of: stem) {
        case .backUnrounded:  return "ı"
        case .backRounded:    return "u"
        case .frontUnrounded: return "i"
        case .frontRounded:   return "ü"
        }
    }

    /// 2-way harmony vowel: a / e
    static func harmony2(for stem: String) -> Character {
        switch lastVowelClass(of: stem) {
        case .backUnrounded, .backRounded:  return "a"
        case .frontUnrounded, .frontRounded: return "e"
        }
    }

    /// Voiceless consonants require `t-`, otherwise `d-` in -DI / -DIK / etc.
    static let voicelessConsonants: Set<Character> = ["p", "ç", "t", "k", "f", "h", "s", "ş"]

    static func lastLetter(_ s: String) -> Character? {
        s.lowercased(with: Locale(identifier: "tr_TR")).last
    }

    static func endsInVowel(_ s: String) -> Bool {
        guard let c = lastLetter(s) else { return false }
        return allVowels.contains(c)
    }

    static func endsInVoiceless(_ s: String) -> Bool {
        guard let c = lastLetter(s) else { return false }
        return voicelessConsonants.contains(c)
    }

    /// Drop the `mek` / `mak` of a dictionary-form verb and apply the
    /// irregular stem voicing (gitmek → gid-, etmek → ed-, tatmak → tad-).
    static func verbStem(from infinitive: String) -> String {
        let lower = infinitive.lowercased(with: Locale(identifier: "tr_TR"))
        var stem: String
        if lower.hasSuffix("mek") || lower.hasSuffix("mak") {
            stem = String(lower.dropLast(3))
        } else {
            stem = lower
        }
        // Irregular voicing for 1-syllable stems ending in t.
        let voicing: [String: String] = [
            "git": "gid",
            "et":  "ed",
            "tat": "tad",
            "güt": "güd",
        ]
        if let voiced = voicing[stem] { return voiced }
        return stem
    }

    // MARK: - Tenses

    enum Tense: String, CaseIterable, Identifiable {
        case present         = "Present Continuous (-iyor)"
        case aorist          = "Aorist (-er/-ir)"
        case pastWitness     = "Simple Past -DI (witnessed)"
        case pastReported    = "Reported Past -mIş"
        case future          = "Future -(y)AcAK"
        case necessity       = "Necessity -mAlI"
        case conditional     = "Conditional -sA"
        case imperative      = "Imperative"

        var id: String { rawValue }
    }

    enum Person: String, CaseIterable, Identifiable {
        case s1 = "ben"
        case s2 = "sen"
        case s3 = "o"
        case p1 = "biz"
        case p2 = "siz"
        case p3 = "onlar"

        var id: String { rawValue }
        var english: String {
            switch self {
            case .s1: return "I"
            case .s2: return "you (sg)"
            case .s3: return "he/she/it"
            case .p1: return "we"
            case .p2: return "you (pl)"
            case .p3: return "they"
            }
        }
    }

    /// Top-level API: fully conjugate a Turkish infinitive across all tenses × persons.
    static func conjugate(_ infinitive: String) -> [(tense: Tense, person: Person, form: String)] {
        let stem = verbStem(from: infinitive)
        var out: [(Tense, Person, String)] = []
        for t in Tense.allCases {
            for p in Person.allCases {
                out.append((t, p, form(tense: t, person: p, stem: stem)))
            }
        }
        return out
    }

    // MARK: - Suffix builders

    private static func personalEnding(_ p: Person, harmonyVowel: Character) -> String {
        switch p {
        case .s1: return "\(harmonyVowel)m"
        case .s2: return "s\(harmonyVowel)n"
        case .s3: return ""
        case .p1: return "\(harmonyVowel)z"
        case .p2: return "s\(harmonyVowel)n\(harmonyVowel2(for: harmonyVowel))z"
        case .p3: return "l\(harmony2(for: String(harmonyVowel)))r"
        }
    }

    // Plural "ın/in/un/ün" based on previous 4-way vowel.
    private static func harmonyVowel2(for v: Character) -> Character { v }

    static func form(tense: Tense, person: Person, stem: String) -> String {
        switch tense {
        case .present:       return presentContinuous(stem: stem, person: person)
        case .aorist:        return aorist(stem: stem, person: person)
        case .pastWitness:   return pastWitness(stem: stem, person: person)
        case .pastReported:  return pastReported(stem: stem, person: person)
        case .future:        return future(stem: stem, person: person)
        case .necessity:     return necessity(stem: stem, person: person)
        case .conditional:   return conditional(stem: stem, person: person)
        case .imperative:    return imperative(stem: stem, person: person)
        }
    }

    // -iyor
    private static func presentContinuous(stem: String, person: Person) -> String {
        var s = stem
        // Drop final vowel before -iyor for vowel-final stems: bekle → bekliyor.
        if let last = s.last, allVowels.contains(last) { s.removeLast() }
        let buffer = "\(harmony4(for: s))yor"
        let endings: [Person: String] = [
            .s1: "um", .s2: "sun", .s3: "", .p1: "uz", .p2: "sunuz", .p3: "lar"
        ]
        return s + buffer + (endings[person] ?? "")
    }

    /// 13 common monosyllabic verbs that are the exception to the "-Ar for
    /// monosyllabic consonant stems" rule — they take -Ir/-İr/-Ur/-Ür instead.
    /// See Göksel & Kerslake §21.2.1.
    static let aoristIrregularIr: Set<String> = [
        "al", "bil", "bul", "dur", "gel", "gör",
        "kal", "ol", "öl", "san", "var", "ver", "vur",
    ]

    // Aorist: -Ir for vowel-final & polysyllabic; -Ar for single-syllable
    // consonant stems, with a fixed exception list for the 13 common verbs
    // that also take -Ir/-İr/-Ur/-Ür.
    private static func aorist(stem: String, person: Person) -> String {
        let vowel: Character
        if endsInVowel(stem) {
            vowel = harmony4(for: stem)
        } else if aoristIrregularIr.contains(stem) {
            vowel = harmony4(for: stem)
        } else {
            // crude syllable heuristic: single-syllable stems use -Ar, others -Ir.
            let vowelCount = stem.filter { allVowels.contains($0) }.count
            vowel = vowelCount <= 1 ? harmony2(for: stem) : harmony4(for: stem)
        }
        let r = "r"
        let base = stem + (endsInVowel(stem) ? "\(r)" : "\(vowel)\(r)")
        return base + personalSuffixAorist(person: person, stem: base)
    }

    private static func personalSuffixAorist(person: Person, stem: String) -> String {
        let v = harmony4(for: stem)
        switch person {
        case .s1: return "\(v)m"
        case .s2: return "s\(v)n"
        case .s3: return ""
        case .p1: return "\(v)z"
        case .p2: return "s\(v)n\(v)z"
        case .p3: return "l\(harmony2(for: stem))r"
        }
    }

    // -DI past witness
    private static func pastWitness(stem: String, person: Person) -> String {
        let d: Character = endsInVoiceless(stem) ? "t" : "d"
        let v = harmony4(for: stem)
        let root = "\(stem)\(d)\(v)"
        switch person {
        case .s1: return root + "m"
        case .s2: return root + "n"
        case .s3: return root
        case .p1: return root + "k"
        case .p2: return root + "n\(v)z"
        case .p3: return root + "l\(harmony2(for: stem))r"
        }
    }

    // -mIş reported past
    private static func pastReported(stem: String, person: Person) -> String {
        let v = harmony4(for: stem)
        let root = "\(stem)m\(v)ş"
        return root + personalEnding(person, harmonyVowel: v)
    }

    // -(y)AcAK future
    private static func future(stem: String, person: Person) -> String {
        let bridge = endsInVowel(stem) ? "y" : ""
        let a: Character = harmony2(for: stem)
        let root = "\(stem)\(bridge)\(a)c\(a)k"
        // k → ğ before vowel-initial suffixes in 1sg/1pl.
        let i = harmony4(for: root)
        let ar = harmony2(for: root)
        switch person {
        case .s1: return String(root.dropLast()) + "ğ\(i)m"
        case .s2: return root + "s\(i)n"
        case .s3: return root
        case .p1: return String(root.dropLast()) + "ğ\(i)z"
        case .p2: return root + "s\(i)n\(i)z"
        case .p3: return root + "l\(ar)r"
        }
    }

    // -mAlI necessity
    private static func necessity(stem: String, person: Person) -> String {
        let a: Character = harmony2(for: stem)
        let i: Character = harmony4(for: stem)
        let root = "\(stem)m\(a)l\(i)"
        switch person {
        case .s1: return root + "y\(i)m"
        case .s2: return root + "s\(i)n"
        case .s3: return root
        case .p1: return root + "y\(i)z"
        case .p2: return root + "s\(i)n\(i)z"
        case .p3: return root + "l\(a)r"
        }
    }

    // -sA conditional
    private static func conditional(stem: String, person: Person) -> String {
        let a: Character = harmony2(for: stem)
        let i: Character = harmony4(for: stem)
        let root = "\(stem)s\(a)"
        switch person {
        case .s1: return root + "m"
        case .s2: return root + "n"
        case .s3: return root
        case .p1: return root + "k"
        case .p2: return root + "n\(i)z"
        case .p3: return root + "l\(a)r"
        }
    }

    // Imperative
    private static func imperative(stem: String, person: Person) -> String {
        let i: Character = harmony4(for: stem)
        let a: Character = harmony2(for: stem)
        switch person {
        case .s1: return "— "   // no 1sg imperative
        case .s2: return stem
        case .s3: return "\(stem)s\(i)n"
        case .p1: return "\(stem)\(endsInVowel(stem) ? "y" : "")\(a)l\(i)m"
        case .p2: return "\(stem)\(endsInVowel(stem) ? "y" : "")\(i)n\(i)z"
        case .p3: return "\(stem)s\(i)nl\(a)r"
        }
    }
}
