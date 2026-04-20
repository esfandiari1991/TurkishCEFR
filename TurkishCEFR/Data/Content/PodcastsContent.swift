import Foundation

/// Curated free Turkish-learning podcasts, grouped by CEFR level. All links
/// point to publicly available sources (RSS, YouTube, Spotify web player or
/// the show's own site) so the user can listen immediately in their browser.
/// No paid subscription is required for any item in this list.
///
/// Where a podcast doesn't have a strict level (native news, culture, etc.)
/// we tag it with the lowest level where learners typically start
/// benefiting. A user can always bump up to a harder show.
struct PodcastEpisodeLink: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let subtitle: String
    /// Primary public URL where the user can start listening immediately.
    let url: URL
    /// Optional RSS feed for users who want to subscribe in their own client.
    let rss: URL?
    /// Approximate episode length (e.g. "10 min").
    let length: String
    /// Primary language pair, e.g. "Turkish + English".
    let language: String
    /// Whether transcripts / show-notes exist for the episode.
    let hasTranscript: Bool
}

struct PodcastShow: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let host: String
    let levels: [String]             // e.g. ["A1", "A2"]
    let summary: String
    let tagline: String
    let url: URL                     // landing page
    let rss: URL?
    let systemImage: String
    let accent: String               // e.g. "Istanbul Turkish"
}

enum PodcastsContent {

    static let shows: [PodcastShow] = [

        // MARK: - A1 — complete beginner
        PodcastShow(
            id: "turkishteatime",
            title: "Turkish Tea Time",
            host: "Çiğdem Kurt",
            levels: ["A1", "A2"],
            summary: "A warm, slow-paced podcast for absolute beginners. Every episode introduces a short dialogue line-by-line, with clear English explanations of grammar and vocabulary. Free episodes go back years and cover the full A1 syllabus.",
            tagline: "Slow dialogues, line-by-line, beginner-friendly.",
            url: URL(string: "https://turkishteatime.com")!,
            rss:  URL(string: "https://turkishteatime.com/podcast.rss"),
            systemImage: "cup.and.saucer.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "turkishpod101",
            title: "TurkishPod101 (Free Tier)",
            host: "Innovative Language",
            levels: ["A1", "A2", "B1"],
            summary: "The lifetime-free beginner lessons cover the alphabet, survival phrases, basic grammar and conversation. Browse through the Absolute Beginner and Beginner series without a subscription.",
            tagline: "Absolute-beginner lessons, free lifetime access.",
            url: URL(string: "https://www.turkishpod101.com/index.php?cat=Free%20Lessons")!,
            rss:  nil,
            systemImage: "book.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "letslearnturkish",
            title: "Let's Learn Turkish",
            host: "Meren Kanal",
            levels: ["A1"],
            summary: "YouTube podcast-style series for absolute beginners. Each episode is 5–10 minutes of very slow, very clear Turkish with on-screen subtitles and grammar notes.",
            tagline: "5-minute beginner episodes with subtitles.",
            url: URL(string: "https://www.youtube.com/@LetsLearnTurkish")!,
            rss:  nil,
            systemImage: "play.rectangle.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "tkolayturkce",
            title: "Kolay Türkçe",
            host: "Turkish Language Foundation",
            levels: ["A1", "A2"],
            summary: "\"Easy Turkish\" — short weekly episodes covering everyday topics (food, weather, family) in simplified grammar. Each episode has a PDF transcript.",
            tagline: "Short easy-Turkish episodes with PDF transcripts.",
            url: URL(string: "https://www.kolayturkce.com")!,
            rss:  nil,
            systemImage: "doc.text.fill",
            accent: "Istanbul Turkish"
        ),

        // MARK: - A2 — elementary
        PodcastShow(
            id: "turkishwithelif",
            title: "Turkish with Elif",
            host: "Elif Güler",
            levels: ["A2", "B1"],
            summary: "Weekly conversational episodes on culture, travel and daily life in Istanbul. Elif speaks a touch faster than TurkishTeaTime but still pauses for learners and explains new vocabulary.",
            tagline: "Cultural conversations at learner pace.",
            url: URL(string: "https://turkishwithelif.com")!,
            rss:  URL(string: "https://anchor.fm/s/turkishwithelif/podcast/rss"),
            systemImage: "leaf.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "turkishcoffeebreak",
            title: "Coffee Break Turkish",
            host: "Radio Lingua Network",
            levels: ["A2", "B1"],
            summary: "From the Coffee Break language family — bite-sized 15-minute lessons organised by level. Free episodes live on Apple Podcasts, Spotify and Audible.",
            tagline: "15-minute structured lessons, free weekly.",
            url: URL(string: "https://radiolingua.com/coffeebreakturkish/")!,
            rss:  URL(string: "https://feeds.megaphone.fm/coffeebreakturkish"),
            systemImage: "mug.fill",
            accent: "Istanbul Turkish"
        ),

        // MARK: - B1 — intermediate
        PodcastShow(
            id: "dostanepod",
            title: "Dostane Türkçe",
            host: "Ayşe Güven",
            levels: ["B1", "B2"],
            summary: "A Turkish-only podcast at natural but measured speed. Topics include friendship, books, cities, and personal stories. Show notes include vocabulary lists.",
            tagline: "Turkish-only, measured pace, cultural depth.",
            url: URL(string: "https://dostaneturkce.com")!,
            rss:  URL(string: "https://anchor.fm/s/dostane/podcast/rss"),
            systemImage: "person.2.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "turkishwithmira",
            title: "Turkish with Mira",
            host: "Mira Aslan",
            levels: ["B1"],
            summary: "Twenty-minute podcast-style lessons where Mira tells a short story in simple B1 Turkish, then unpacks the grammar and idioms. Transcripts posted on her website.",
            tagline: "Short-story lessons with free transcripts.",
            url: URL(string: "https://www.turkishwithmira.com")!,
            rss:  nil,
            systemImage: "book.pages.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "realturkish",
            title: "Real Turkish Podcast",
            host: "Hakan & Zeynep",
            levels: ["B1", "B2"],
            summary: "Unscripted conversations between two native hosts on whatever's in the news that week — perfect for intermediate learners who want realistic listening practice.",
            tagline: "Unscripted native conversation.",
            url: URL(string: "https://open.spotify.com/show/4iEjOYNrPmSsfmZbEswCQn")!,
            rss:  nil,
            systemImage: "waveform",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "easyturkish",
            title: "Easy Turkish (Street Interviews)",
            host: "Easy Languages",
            levels: ["B1", "B2"],
            summary: "YouTube / podcast format with bilingual Turkish-English subtitles. Street interviews in İstanbul, İzmir and Ankara expose you to regional variation and real spoken Turkish.",
            tagline: "Native street interviews with bilingual subs.",
            url: URL(string: "https://www.youtube.com/@EasyTurkish")!,
            rss:  nil,
            systemImage: "video.fill",
            accent: "Mixed Turkish"
        ),

        // MARK: - B2 — upper-intermediate
        PodcastShow(
            id: "aposto",
            title: "Aposto! Podcast",
            host: "Aposto Haber",
            levels: ["B2", "C1"],
            summary: "Daily Turkish news podcast from Aposto! Short, punchy episodes on politics, business and culture at native speed — a great bridge from B1 listening material to real media.",
            tagline: "Daily native-speed news podcast.",
            url: URL(string: "https://aposto.co/podcast")!,
            rss:  URL(string: "https://feeds.transistor.fm/aposto-podcast"),
            systemImage: "newspaper.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "medyascope",
            title: "Medyascope Podcast",
            host: "Medyascope",
            levels: ["B2", "C1"],
            summary: "Independent digital newsroom's podcast feed: interviews, analysis and daily news rundowns. Streaming for free on their website and all major podcast apps.",
            tagline: "Independent Turkish journalism, free.",
            url: URL(string: "https://medyascope.tv/podcast/")!,
            rss:  URL(string: "https://anchor.fm/s/11b2bc00/podcast/rss"),
            systemImage: "antenna.radiowaves.left.and.right",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "trtradyo1",
            title: "TRT Radyo 1 — Seçilmiş Programlar",
            host: "TRT",
            levels: ["B2", "C1", "C2"],
            summary: "Turkey's state broadcaster puts a large on-demand archive online for free: news magazines, cultural programmes, literature readings. A deep well of native content.",
            tagline: "Turkish state-broadcast archive, free.",
            url: URL(string: "https://www.trtradyo1.com.tr/podcast")!,
            rss:  nil,
            systemImage: "tv.fill",
            accent: "Istanbul Turkish"
        ),

        // MARK: - C1 — advanced
        PodcastShow(
            id: "dinle",
            title: "Dinle",
            host: "Ayşe Türkoğlu",
            levels: ["C1"],
            summary: "Philosophy, psychology, and deep-dive culture episodes aimed at native speakers. At C1 you'll catch the nuance; at B2 it's great stretch material.",
            tagline: "Long-form culture & philosophy podcast.",
            url: URL(string: "https://open.spotify.com/show/2nLFUqHTqLX3L06Kn86ywX")!,
            rss:  nil,
            systemImage: "brain.head.profile",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "dünyahalleri",
            title: "Dünya Halleri",
            host: "Candaş Tolga Işık",
            levels: ["C1", "C2"],
            summary: "Long-form interviews with artists, authors, scientists and entrepreneurs. Fast, articulate Istanbul Turkish with plenty of idiom.",
            tagline: "Long-form native interviews.",
            url: URL(string: "https://open.spotify.com/show/4JhX9yZ6bO0gQRDqlWfLNH")!,
            rss:  nil,
            systemImage: "globe.europe.africa.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "bbcturkce",
            title: "BBC News Türkçe Podcasts",
            host: "BBC",
            levels: ["C1"],
            summary: "BBC's Turkish service publishes daily news rundowns and weekly deep-dives. Clean, standard journalism Turkish — perfect for advanced comprehension training.",
            tagline: "BBC-quality Turkish-language journalism.",
            url: URL(string: "https://www.bbc.com/turkce/podcasts")!,
            rss:  nil,
            systemImage: "dot.radiowaves.left.and.right",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "fenbilim",
            title: "Fen ve Bilim",
            host: "Çağrı Mert Bakırcı",
            levels: ["C1", "C2"],
            summary: "Evolutionary biologist Bakırcı's science podcast. Technical vocabulary, fast-paced delivery — a workout for C1+ listeners who want to learn *in* Turkish.",
            tagline: "Science explained in advanced Turkish.",
            url: URL(string: "https://evrimagaci.org/podcast")!,
            rss:  nil,
            systemImage: "atom",
            accent: "Istanbul Turkish"
        ),

        // MARK: - C2 — near-native
        PodcastShow(
            id: "edebiyat",
            title: "Edebiyat Söyleşileri",
            host: "Kültür Servisi",
            levels: ["C2"],
            summary: "Literary interviews with Turkish poets and novelists — a celebration of literary register, Ottoman borrowings, and dense metaphor. At this level you're listening for nuance, not survival.",
            tagline: "Literary register, Ottoman vocabulary, deep Turkish.",
            url: URL(string: "https://kulturservisi.com/podcast")!,
            rss:  nil,
            systemImage: "books.vertical.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "açıkradyopod",
            title: "Açık Radyo Podcast Arşivi",
            host: "Açık Radyo 95.0",
            levels: ["C1", "C2"],
            summary: "İstanbul's legendary independent radio station shares much of its archive free online: jazz, politics, science, art. Range of speaking styles and vocabularies.",
            tagline: "Independent radio archive — diverse registers.",
            url: URL(string: "https://acikradyo.com.tr/podcast-arsivi")!,
            rss:  nil,
            systemImage: "radio.fill",
            accent: "Istanbul Turkish"
        ),
        PodcastShow(
            id: "türkçepoetika",
            title: "Şiir Saati",
            host: "TRT",
            levels: ["C2"],
            summary: "Weekly poetry reading programme on TRT Radyo — works from Yahya Kemal, Nâzım Hikmet, İlhan Berk. Slow, reverent delivery designed for listening to the music of the language.",
            tagline: "Turkish poetry read aloud, for the ear.",
            url: URL(string: "https://www.trtradyo.com.tr/siir-saati")!,
            rss:  nil,
            systemImage: "music.note.list",
            accent: "Istanbul Turkish"
        )
    ]

    static func shows(for level: CEFRLevel) -> [PodcastShow] {
        shows.filter { $0.levels.contains(level.rawValue) }
    }

    static var byLevel: [(level: CEFRLevel, shows: [PodcastShow])] {
        CEFRLevel.allCases.map { (level: $0, shows: shows(for: $0)) }
    }
}
