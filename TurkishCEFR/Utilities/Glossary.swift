import SwiftUI

/// A plain-language glossary of linguistic / grammar jargon. An A1 learner
/// shouldn't need a linguistics degree to follow the app — every time one of
/// these terms appears in the UI we wrap it in `GlossaryTerm` which shows a
/// popover with a beginner-friendly explanation plus a Turkish example.
enum Glossary {
    struct Entry: Identifiable, Hashable {
        let id: String
        let term: String
        let plainEnglish: String
        let exampleTR: String?
        let exampleEN: String?
    }

    /// All entries keyed by their normalised lookup form (lowercased, no punctuation).
    static let all: [String: Entry] = Dictionary(uniqueKeysWithValues: entries.map { (Self.normalise($0.term), $0) })

    static func normalise(_ s: String) -> String {
        s.lowercased()
         .replacingOccurrences(of: "-", with: "")
         .replacingOccurrences(of: " ", with: "")
         .trimmingCharacters(in: .punctuationCharacters)
    }

    static func entry(for term: String) -> Entry? {
        all[normalise(term)]
    }

    static let entries: [Entry] = [
        Entry(id: "nominative", term: "nominative",
              plainEnglish: "The base form of a word, the one you find in the dictionary. In Turkish this is the subject of a sentence — the one doing the action.",
              exampleTR: "Kedi uyuyor.", exampleEN: "The cat is sleeping. (\"kedi\" is in the nominative.)"),
        Entry(id: "accusative", term: "accusative",
              plainEnglish: "The case for a definite direct object (\"the book\", \"that book\"). Turkish marks it with a vowel-harmony suffix: -ı / -i / -u / -ü.",
              exampleTR: "Kitabı okuyorum.", exampleEN: "I'm reading THE book."),
        Entry(id: "dative", term: "dative",
              plainEnglish: "The \"to / toward\" case. Added to a noun to mean movement toward it. Suffix: -a / -e.",
              exampleTR: "Eve gidiyorum.", exampleEN: "I'm going home (to the house)."),
        Entry(id: "locative", term: "locative",
              plainEnglish: "The \"at / in / on\" case, marking location. Suffix: -da / -de / -ta / -te.",
              exampleTR: "Okulda öğretmenim.", exampleEN: "I'm a teacher at the school."),
        Entry(id: "ablative", term: "ablative",
              plainEnglish: "The \"from / out of\" case. Suffix: -dan / -den / -tan / -ten.",
              exampleTR: "İstanbul'dan geliyorum.", exampleEN: "I'm coming from Istanbul."),
        Entry(id: "genitive", term: "genitive",
              plainEnglish: "The possessor case — \"of\". Suffix: -ın / -in / -un / -ün.",
              exampleTR: "Ali'nin kitabı", exampleEN: "Ali's book"),
        Entry(id: "vowelharmony", term: "vowel harmony",
              plainEnglish: "The rule that suffixes echo the last vowel of the word. Back vowels (a, ı, o, u) take back-vowel suffixes; front vowels (e, i, ö, ü) take front-vowel suffixes. You'll see it everywhere.",
              exampleTR: "ev-LER vs. kitap-LAR", exampleEN: "houses vs. books"),
        Entry(id: "agglutinative", term: "agglutinative",
              plainEnglish: "A language that builds words by stacking suffixes onto a root, each carrying one piece of meaning. Turkish does this constantly.",
              exampleTR: "ev-ler-iniz-den", exampleEN: "from your (plural) houses"),
        Entry(id: "suffix", term: "suffix",
              plainEnglish: "A small piece added to the end of a word to change its meaning or role. Turkish builds almost everything with suffixes.",
              exampleTR: "öğret-men-lik", exampleEN: "teacher-profession → teaching"),
        Entry(id: "root", term: "root",
              plainEnglish: "The core part of a word before any suffix is added. Usually what you look up in the dictionary.",
              exampleTR: "git- (to go)", exampleEN: "gid-iyor-um = I am going"),
        Entry(id: "aorist", term: "aorist",
              plainEnglish: "A Turkish tense for general / habitual truths (\"I drink tea\"). Formed with -ır / -ir / -ur / -ür / -r.",
              exampleTR: "Ben çay içerim.", exampleEN: "I drink tea (as a habit)."),
        Entry(id: "conjugation", term: "conjugation",
              plainEnglish: "The set of forms a verb takes to show who's doing it and when. \"I go\", \"you went\", etc.",
              exampleTR: "gidiyor-um / gidiyor-sun / gidiyor", exampleEN: "I'm going / you're going / he-she is going"),
        Entry(id: "copula", term: "copula",
              plainEnglish: "A linking word like \"am/is/are\". Turkish often shows the copula with a suffix (-im, -sin, -dir) rather than a separate word.",
              exampleTR: "Ben öğretmenim.", exampleEN: "I am a teacher."),
        Entry(id: "imperative", term: "imperative",
              plainEnglish: "The command form of a verb. \"Go!\", \"Sit!\".",
              exampleTR: "Gel!", exampleEN: "Come!"),
        Entry(id: "participle", term: "participle",
              plainEnglish: "A verb form acting like an adjective — \"the running boy\", \"the book I read\". Turkish has -en/-an, -dık, -acak participles.",
              exampleTR: "koşan çocuk", exampleEN: "the running boy"),
        Entry(id: "possessive", term: "possessive",
              plainEnglish: "A suffix showing ownership: my, your, his/her, our, their. In Turkish: -im, -in, -i, -imiz, -iniz, -leri.",
              exampleTR: "kitab-ım / kitab-ın", exampleEN: "my book / your book"),
        Entry(id: "plural", term: "plural",
              plainEnglish: "More than one. Turkish uses -lar / -ler.",
              exampleTR: "ev-ler", exampleEN: "houses"),
        Entry(id: "morphology", term: "morphology",
              plainEnglish: "The study of how words are built from smaller pieces. In Turkish, this matters a lot because suffixes do so much work.",
              exampleTR: "", exampleEN: ""),
        Entry(id: "syntax", term: "syntax",
              plainEnglish: "How words are arranged into sentences. Turkish prefers Subject–Object–Verb.",
              exampleTR: "Ben kitap okuyorum.", exampleEN: "I (a) book am-reading → I'm reading a book."),
        Entry(id: "infinitive", term: "infinitive",
              plainEnglish: "The dictionary form of a verb, ending in -mak or -mek. \"to do\", \"to go\".",
              exampleTR: "gitmek", exampleEN: "to go"),
        Entry(id: "gerund", term: "gerund",
              plainEnglish: "A verb form acting like a noun. Turkish often uses -me/-ma for this.",
              exampleTR: "yüzmeyi seviyorum", exampleEN: "I love swimming"),
        Entry(id: "aspect", term: "aspect",
              plainEnglish: "Whether an action is ongoing, finished, habitual, etc. Turkish distinguishes progressive (-iyor), habitual (-ır), completed (-dı).",
              exampleTR: "", exampleEN: ""),
        Entry(id: "tense", term: "tense",
              plainEnglish: "When an action happens: past, present, future. Turkish has several of each.",
              exampleTR: "", exampleEN: ""),
        Entry(id: "modal", term: "modal",
              plainEnglish: "Words like \"must\", \"can\", \"should\". Turkish builds these with suffixes: -malı, -abil-, and helper verbs.",
              exampleTR: "Gitmeliyim.", exampleEN: "I must go."),
        Entry(id: "relativeclause", term: "relative clause",
              plainEnglish: "A part of a sentence that describes a noun: \"the book that I read\". Turkish uses participles (-dık, -an, -acak) instead of \"that/which\".",
              exampleTR: "Okuduğum kitap", exampleEN: "The book (that) I read"),
        Entry(id: "passive", term: "passive",
              plainEnglish: "When the object of the action becomes the subject: \"the book was read\". In Turkish: -il / -ıl suffix.",
              exampleTR: "Kitap okundu.", exampleEN: "The book was read."),
        Entry(id: "causative", term: "causative",
              plainEnglish: "Making someone else do the action: \"I made him do it\". Turkish uses -dır / -t / -ır suffixes.",
              exampleTR: "Kitabı ona okut-tum.", exampleEN: "I made him read the book."),
        Entry(id: "reflexive", term: "reflexive",
              plainEnglish: "Doing the action to oneself. Turkish uses the -n- suffix.",
              exampleTR: "Yıkan-dı.", exampleEN: "He/She washed himself/herself."),
        Entry(id: "ipa", term: "IPA",
              plainEnglish: "International Phonetic Alphabet — a universal set of symbols for the sounds of any language, so you know exactly how to say a word.",
              exampleTR: "merhaba", exampleEN: "[ˈmeɾhaba]"),
        Entry(id: "pos", term: "part of speech",
              plainEnglish: "The job a word does: noun, verb, adjective, adverb, etc.",
              exampleTR: "", exampleEN: "")
    ]
}

/// Wraps a piece of text such that hovering or clicking it reveals a popover
/// defining the linguistic term in beginner-friendly language.
struct GlossaryTerm: View {
    let term: String
    var font: Font = .callout.weight(.semibold)
    var color: Color = .accentColor

    @State private var showPopover: Bool = false

    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            HStack(spacing: 2) {
                Text(term).font(font).foregroundStyle(color)
                Image(systemName: "questionmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(color.opacity(0.6))
            }
        }
        .buttonStyle(.plain)
        .help("What does \"\(term)\" mean? Click to learn.")
        .popover(isPresented: $showPopover, arrowEdge: .top) {
            GlossaryPopoverContent(term: term)
                .frame(width: 340)
                .padding(Spacing.md)
        }
    }
}

private struct GlossaryPopoverContent: View {
    let term: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "book.closed.fill").foregroundStyle(.accent)
                Text(term.capitalized)
                    .font(.title3.weight(.bold))
            }
            if let entry = Glossary.entry(for: term) {
                Text(entry.plainEnglish)
                    .font(DisplayFont.body)
                    .lineSpacing(LineHeight.body)
                if let tr = entry.exampleTR, !tr.isEmpty,
                   let en = entry.exampleEN, !en.isEmpty {
                    Divider().padding(.vertical, 2)
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Example").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                        SpeakableText(text: tr, font: .body.weight(.semibold))
                        Text(en).font(.callout).foregroundStyle(.secondary)
                    }
                    .padding(Spacing.xs)
                    .background(Color.accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                }
            } else {
                Text("No plain-English definition yet for \"\(term)\". Tap any linguistic term in the app to learn more.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
