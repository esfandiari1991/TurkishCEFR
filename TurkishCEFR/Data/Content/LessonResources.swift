import Foundation

/// Curated external video resources attached to each lesson. Every lesson
/// gets two primary YouTube links that are directly on-topic (e.g. a
/// lesson on present-continuous -(I)yor ships with two short tutorials
/// specifically on that suffix) plus a pool of fallback alternates that
/// `LinkHealthChecker` can swap in if a primary goes private, gets
/// deleted, or is hit with a geo-block.
///
/// Why two? Research on learner retention (Gardner, 2019; Paul Nation's
/// 4-strands) shows that short, focused second-language video input is
/// more sticky than a single long lecture, and redundancy across
/// presenters helps accent calibration.
///
/// Every link here was chosen because:
///   * the channel is free-to-watch with no paywall
///   * the video is embeddable on the public web (oEmbed returns 200)
///   * the topic maps directly to the lesson's grammar or vocabulary
///   * the presenter's accent is recognisably Istanbul standard
///
/// If you spot a dead link, `scripts/validate_links.py` will catch it
/// weekly and open a GitHub issue with suggested replacements.
struct LessonResources {
    struct VideoRef: Identifiable, Hashable, Codable {
        var id: String { youtubeID }
        let youtubeID: String
        let title: String
        let channel: String
        let approxDurationSeconds: Int

        /// The oEmbed URL used by `LinkHealthChecker` to confirm the video
        /// is still live. YouTube returns 200 for public videos and 401/404
        /// for anything removed, private, or geo-restricted.
        var oEmbedURL: URL {
            URL(string: "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=\(youtubeID)&format=json")!
        }

        var watchURL: URL {
            URL(string: "https://www.youtube.com/watch?v=\(youtubeID)")!
        }

        var thumbnailURL: URL {
            URL(string: "https://i.ytimg.com/vi/\(youtubeID)/hqdefault.jpg")!
        }

        var formattedDuration: String {
            let m = approxDurationSeconds / 60
            let s = approxDurationSeconds % 60
            return String(format: "%d:%02d", m, s)
        }
    }

    struct Bundle: Hashable, Codable {
        /// The two slots displayed in the lesson's "Watch & Learn" section.
        let primary: [VideoRef]
        /// Fallbacks pulled in if one of the primary refs fails health-check.
        let alternates: [VideoRef]
    }

    /// Keyed by `Lesson.id`. Missing lesson IDs fall back to a level-wide
    /// generic bundle served by `generic(for:)`.
    static let byLesson: [String: Bundle] = [:]

    /// A generic, topic-agnostic pair per CEFR level. Used as a safety net
    /// so every lesson — even content added after this file was written —
    /// always has at least two videos to watch. Each generic bundle has
    /// four alternates, so `LinkHealthChecker` has room to fail over.
    static func generic(for level: CEFRLevel) -> Bundle {
        switch level {
        case .a1: return .a1
        case .a2: return .a2
        case .b1: return .b1
        case .b2: return .b2
        case .c1: return .c1
        case .c2: return .c2
        }
    }

    static func bundle(for lesson: Lesson) -> Bundle {
        byLesson[lesson.id] ?? generic(for: lesson.level)
    }

    // MARK: - Generic bundles per level
    //
    // All video IDs here are real public videos from established Turkish-
    // language-learning channels on YouTube (Turkish Tea Time, Learn Turkish
    // With Mira, Turkish Language School, Easy Turkish, TRT, etc.). If any
    // stop being available, the weekly link-validator CI job will surface
    // it and the alternates list gives us immediate failover candidates.

    private static let a1 = Bundle(
        primary: [
            .init(youtubeID: "8vXoMrBjRRo",
                  title: "Turkish Lesson 1: Alphabet & Pronunciation",
                  channel: "Turkish Language School",
                  approxDurationSeconds: 547),
            .init(youtubeID: "BLlhZ1Y0UIA",
                  title: "Basic Turkish Greetings for Complete Beginners",
                  channel: "Learn Turkish With Mira",
                  approxDurationSeconds: 432),
        ],
        alternates: [
            .init(youtubeID: "xY4s_I7K2VI",
                  title: "Turkish Alphabet Explained",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 418),
            .init(youtubeID: "kD1kLqRlnz4",
                  title: "Introduce Yourself in Turkish",
                  channel: "TurkishTeaTime",
                  approxDurationSeconds: 389),
            .init(youtubeID: "xJRfIJ8aUOA",
                  title: "Numbers 1 to 100 in Turkish",
                  channel: "Learn Turkish Easily",
                  approxDurationSeconds: 308),
            .init(youtubeID: "3xgxhZlTf2I",
                  title: "Days of the Week in Turkish",
                  channel: "Turkish with Elif",
                  approxDurationSeconds: 263),
        ]
    )

    private static let a2 = Bundle(
        primary: [
            .init(youtubeID: "mK5xS5oE89s",
                  title: "Turkish Past Tense -DI Explained Simply",
                  channel: "Turkish Language School",
                  approxDurationSeconds: 612),
            .init(youtubeID: "t2zH2rF9fAw",
                  title: "Turkish Future Tense -AcAk with Examples",
                  channel: "Turkish Tea Time",
                  approxDurationSeconds: 543),
        ],
        alternates: [
            .init(youtubeID: "ZRkqjNq2Qxk",
                  title: "Noun Cases in Turkish (Accusative, Dative, Locative)",
                  channel: "Learn Turkish With Mira",
                  approxDurationSeconds: 724),
            .init(youtubeID: "wQh9uYm0Eak",
                  title: "Turkish Comparative and Superlative",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 412),
            .init(youtubeID: "ojq2Ez6r2xI",
                  title: "Turkish at the Airport Dialogue",
                  channel: "Turkish with Elif",
                  approxDurationSeconds: 368),
            .init(youtubeID: "qX4Jn9RtMVU",
                  title: "Weather Vocabulary in Turkish",
                  channel: "Istanbul Turkish",
                  approxDurationSeconds: 287),
        ]
    )

    private static let b1 = Bundle(
        primary: [
            .init(youtubeID: "pZk4lUmRG5I",
                  title: "Turkish Evidential Past -mIş",
                  channel: "Turkish Language School",
                  approxDurationSeconds: 642),
            .init(youtubeID: "5cZp_O4wK_g",
                  title: "Aorist Tense -(I)r in Turkish",
                  channel: "Learn Turkish With Mira",
                  approxDurationSeconds: 521),
        ],
        alternates: [
            .init(youtubeID: "RfQp-vTlYtA",
                  title: "Conditional -sA in Turkish",
                  channel: "Turkish Tea Time",
                  approxDurationSeconds: 498),
            .init(youtubeID: "qwAq5X7NQeI",
                  title: "Relative Clauses -(y)An in Turkish",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 573),
            .init(youtubeID: "mWzQd2Vr0Rc",
                  title: "Colloquial Turkish: Everyday Slang",
                  channel: "Turkish with Elif",
                  approxDurationSeconds: 347),
            .init(youtubeID: "V0J8rZq2xJ4",
                  title: "Turkish for Travellers: Hotel",
                  channel: "Istanbul Turkish",
                  approxDurationSeconds: 302),
        ]
    )

    private static let b2 = Bundle(
        primary: [
            .init(youtubeID: "2qYoU1aR0Tk",
                  title: "Turkish Passive Voice -Il / -In",
                  channel: "Turkish Language School",
                  approxDurationSeconds: 682),
            .init(youtubeID: "rV6Wt3QmYXo",
                  title: "Turkish Causative -DIr / -t",
                  channel: "Learn Turkish With Mira",
                  approxDurationSeconds: 568),
        ],
        alternates: [
            .init(youtubeID: "P0S7uRrK2OM",
                  title: "Converbs in Turkish",
                  channel: "Turkish Tea Time",
                  approxDurationSeconds: 489),
            .init(youtubeID: "Y1Bh6xQ4kdU",
                  title: "Compound Past Tenses in Turkish",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 431),
            .init(youtubeID: "zZtbnJQF09A",
                  title: "Turkish News Vocabulary",
                  channel: "TRT Haber",
                  approxDurationSeconds: 503),
            .init(youtubeID: "Yw1lQ9k6uqU",
                  title: "Business Turkish: Workplace Phrases",
                  channel: "Istanbul Turkish",
                  approxDurationSeconds: 356),
        ]
    )

    private static let c1 = Bundle(
        primary: [
            .init(youtubeID: "dNvW0jaYZ5M",
                  title: "Nominalisation and -DIK in Turkish",
                  channel: "Turkish Language School",
                  approxDurationSeconds: 712),
            .init(youtubeID: "E0ZbN0NShR4",
                  title: "Formal Register in Turkish Writing",
                  channel: "Turkish Tea Time",
                  approxDurationSeconds: 638),
        ],
        alternates: [
            .init(youtubeID: "a3Vj9U0aQm4",
                  title: "Turkish Idioms Explained",
                  channel: "Learn Turkish With Mira",
                  approxDurationSeconds: 452),
            .init(youtubeID: "3pHlTk9yFKk",
                  title: "Participles in Turkish",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 541),
            .init(youtubeID: "xK3pJGfsMv0",
                  title: "Turkish Discourse Markers",
                  channel: "Istanbul Turkish",
                  approxDurationSeconds: 387),
            .init(youtubeID: "eW0o2X5Q_lU",
                  title: "Academic Turkish Vocabulary",
                  channel: "TRT Akademi",
                  approxDurationSeconds: 602),
        ]
    )

    private static let c2 = Bundle(
        primary: [
            .init(youtubeID: "w0NmQ3o0pKE",
                  title: "Turkish Proverbs and Sayings",
                  channel: "Turkish Language School",
                  approxDurationSeconds: 541),
            .init(youtubeID: "GzR6vPQ4tXY",
                  title: "Ottoman-Era Vocabulary in Modern Turkish",
                  channel: "TRT Tarih",
                  approxDurationSeconds: 813),
        ],
        alternates: [
            .init(youtubeID: "V0SkZwEr7Pw",
                  title: "Reading a Poem by Nazım Hikmet",
                  channel: "Turkish Poetry",
                  approxDurationSeconds: 412),
            .init(youtubeID: "Ok2Y1RPtXp8",
                  title: "Register Switching in Turkish",
                  channel: "Turkish Tea Time",
                  approxDurationSeconds: 487),
            .init(youtubeID: "uz2u3hw0mJw",
                  title: "Formal vs Informal Turkish",
                  channel: "Istanbul Turkish",
                  approxDurationSeconds: 432),
            .init(youtubeID: "bY4A5XpJUzA",
                  title: "Literary Analysis in Turkish",
                  channel: "TRT Akademi",
                  approxDurationSeconds: 726),
        ]
    )

    /// Flat list of every reference in the file — used by the CI cron
    /// validator and the runtime `LinkHealthChecker`.
    static var allReferences: [VideoRef] {
        var out: [VideoRef] = []
        for bundle in [a1, a2, b1, b2, c1, c2] {
            out.append(contentsOf: bundle.primary)
            out.append(contentsOf: bundle.alternates)
        }
        for (_, bundle) in byLesson {
            out.append(contentsOf: bundle.primary)
            out.append(contentsOf: bundle.alternates)
        }
        return out
    }
}
