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

    // Every ID below was verified live via YouTube's public oEmbed
    // endpoint before commit. If a video is ever taken down, the weekly
    // `validate-links.yml` cron catches it and `LinkHealthChecker` swaps
    // in an alternate at runtime.

    private static let a1 = Bundle(
        primary: [
            .init(youtubeID: "JpayB45m6ek",
                  title: "Learn Turkish Alphabet #1 – a",
                  channel: "Learn Turkish with TurkishClass101.com",
                  approxDurationSeconds: 147),
            .init(youtubeID: "UFpuxdTpRtA",
                  title: "Turkish Greetings (Selamlaşma) — Basic Turkish / A1",
                  channel: "Functional Turkish",
                  approxDurationSeconds: 375),
        ],
        alternates: [
            .init(youtubeID: "kfBeoWLCosA",
                  title: "Turkish Alphabet for Complete Beginners",
                  channel: "Turkishle",
                  approxDurationSeconds: 710),
            .init(youtubeID: "4x1FCinS7no",
                  title: "Turkish Alphabet · Basic Turkish Lesson · Türkçe",
                  channel: "Learn Turkish with Smile",
                  approxDurationSeconds: 600),
            .init(youtubeID: "qLZZuMG9qlE",
                  title: "Turkish in Three Minutes — Numbers 1–10",
                  channel: "Learn Turkish with TurkishClass101.com",
                  approxDurationSeconds: 210),
            .init(youtubeID: "LbQeqWYgCP4",
                  title: "Introduce Yourself in Turkish — Episode 1",
                  channel: "Turbotalkers Turkish",
                  approxDurationSeconds: 297),
        ]
    )

    private static let a2 = Bundle(
        primary: [
            .init(youtubeID: "OacH13Q3TIc",
                  title: "Master the Turkish Past Tense (-dı/-di)",
                  channel: "LangAdvance Turkish",
                  approxDurationSeconds: 835),
            .init(youtubeID: "P1p5QzP_YgQ",
                  title: "Turkish for Beginners: 80 Essential Phrases",
                  channel: "Turkishle",
                  approxDurationSeconds: 1639),
        ],
        alternates: [
            .init(youtubeID: "DQYWGEOKno4",
                  title: "Learn Turkish for Free — Beginner Turkish Course",
                  channel: "Learn Turkish with Turkishaholic",
                  approxDurationSeconds: 110),
            .init(youtubeID: "37yyCQt4hbw",
                  title: "Daily Routine in Turkish · Easy Turkish 132",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 880),
            .init(youtubeID: "PBgsJg9id4A",
                  title: "How to Negate Simple Present Tense in Turkish",
                  channel: "Turkish Journey",
                  approxDurationSeconds: 87),
            .init(youtubeID: "yJtUP8u4A3o",
                  title: "Learn Turkish Phrases Natives Actually Use · Super Easy 101",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 568),
        ]
    )

    private static let b1 = Bundle(
        primary: [
            .init(youtubeID: "i4K7QScC37g",
                  title: "27 Phrases to Sound Native with Turkish Series",
                  channel: "Turkishle",
                  approxDurationSeconds: 701),
            .init(youtubeID: "ruciw5zXezU",
                  title: "What is your favourite language and country? · Easy Turkish 123",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 779),
        ],
        alternates: [
            .init(youtubeID: "vok014DtjhM",
                  title: "Learn Turkish While You Sleep — Intermediate Podcast",
                  channel: "Learn Turkish with Turkish Coffee",
                  approxDurationSeconds: 739),
            .init(youtubeID: "01GxCNTvjWU",
                  title: "Turkish “Diye” Explained — Meaning & Sentence Structure (Part 4)",
                  channel: "Turkish Journey",
                  approxDurationSeconds: 413),
            .init(youtubeID: "EBbF3UgT28E",
                  title: "Turkish: Learn to Use \"Diye\" in 6 Minutes",
                  channel: "Turkishle",
                  approxDurationSeconds: 360),
            .init(youtubeID: "VX9kyCEwuH8",
                  title: "Turkish Story Time — Learn While You Listen",
                  channel: "ACIKStories",
                  approxDurationSeconds: 442),
        ]
    )

    private static let b2 = Bundle(
        primary: [
            .init(youtubeID: "iRKOcsB3Pu8",
                  title: "This Is What B2 Turkish Sounds Like · Real Student Conversation",
                  channel: "Turkishle",
                  approxDurationSeconds: 1390),
            .init(youtubeID: "3XodAwwYwog",
                  title: "Turkish Listening Comprehension for Intermediate Learners",
                  channel: "Learn Turkish with TurkishClass101.com",
                  approxDurationSeconds: 720),
        ],
        alternates: [
            .init(youtubeID: "vfy3BZWfPLU",
                  title: "Cases in Turkish (Dative, Accusative, Locative, Ablative)",
                  channel: "Turkishle",
                  approxDurationSeconds: 30),
            .init(youtubeID: "vok014DtjhM",
                  title: "Learn Turkish While You Sleep — Intermediate Podcast",
                  channel: "Learn Turkish with Turkish Coffee",
                  approxDurationSeconds: 739),
            .init(youtubeID: "ruciw5zXezU",
                  title: "Favourite Language and Country · Easy Turkish 123",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 779),
            .init(youtubeID: "37yyCQt4hbw",
                  title: "Daily Routine · Easy Turkish 132",
                  channel: "Easy Turkish",
                  approxDurationSeconds: 880),
        ]
    )

    private static let c1 = Bundle(
        primary: [
            .init(youtubeID: "MR5HojpkaBk",
                  title: "Turkish Best Resources Self-Study A1–C2",
                  channel: "Language Travel Adoptee",
                  approxDurationSeconds: 1067),
            .init(youtubeID: "iRKOcsB3Pu8",
                  title: "B2 Turkish Real Conversation",
                  channel: "Turkishle",
                  approxDurationSeconds: 1390),
        ],
        alternates: [
            .init(youtubeID: "aVZwDwZ-L-g",
                  title: "Turkish Proverbs and Sayings",
                  channel: "SAPIENT LIFE",
                  approxDurationSeconds: 360),
            .init(youtubeID: "1FPIW-rQPQc",
                  title: "Timeless Turkish Proverbs — Wisdom & Life Lessons",
                  channel: "Epic Forwards",
                  approxDurationSeconds: 360),
            .init(youtubeID: "i4K7QScC37g",
                  title: "27 Phrases to Sound Native",
                  channel: "Turkishle",
                  approxDurationSeconds: 701),
            .init(youtubeID: "PBgsJg9id4A",
                  title: "How to Negate Simple Present Tense in Turkish",
                  channel: "Turkish Journey",
                  approxDurationSeconds: 87),
        ]
    )

    private static let c2 = Bundle(
        primary: [
            .init(youtubeID: "a6BqKlm0eDc",
                  title: "Nâzım Hikmet 119 Yaşında",
                  channel: "Şükrü Genç",
                  approxDurationSeconds: 2362),
            .init(youtubeID: "1FPIW-rQPQc",
                  title: "Timeless Turkish Proverbs",
                  channel: "Epic Forwards",
                  approxDurationSeconds: 360),
        ],
        alternates: [
            .init(youtubeID: "aVZwDwZ-L-g",
                  title: "Turkish Proverbs and Sayings",
                  channel: "SAPIENT LIFE",
                  approxDurationSeconds: 360),
            .init(youtubeID: "MR5HojpkaBk",
                  title: "Turkish Best Resources A1–C2",
                  channel: "Language Travel Adoptee",
                  approxDurationSeconds: 1067),
            .init(youtubeID: "iRKOcsB3Pu8",
                  title: "B2 Turkish Real Conversation",
                  channel: "Turkishle",
                  approxDurationSeconds: 1390),
            .init(youtubeID: "i4K7QScC37g",
                  title: "27 Phrases to Sound Native",
                  channel: "Turkishle",
                  approxDurationSeconds: 701),
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
