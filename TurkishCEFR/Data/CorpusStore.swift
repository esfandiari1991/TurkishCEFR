import Foundation

/// Loads and exposes the offline Turkish corpus that `scripts/fetch_corpus.py`
/// bakes into the `.app`'s `Resources/` at build time.
///
/// Two datasets are shipped:
/// * `corpus_tr_en.json`   — up to 20 000 curated Turkish↔English sentence
///                            pairs from Tatoeba (CC-BY 2.0 FR).
/// * `frequency_tr.json`   — top 10 000 Turkish words from
///                            hermitdave/FrequencyWords (MIT), ranked by
///                            OpenSubtitles frequency.
///
/// All look-ups are main-thread-safe once the first access has completed the
/// initial decode (≈ 40 ms on Apple Silicon).
@MainActor
final class CorpusStore: ObservableObject {
    static let shared = CorpusStore()

    struct SentencePair: Codable, Hashable, Identifiable {
        let tr: String
        let en: String
        let len: Int
        var id: String { tr }
    }

    struct FrequencyEntry: Codable, Hashable, Identifiable {
        let word: String
        let rank: Int
        let count: Int
        var id: String { word }
    }

    @Published private(set) var pairs: [SentencePair] = []
    @Published private(set) var frequency: [FrequencyEntry] = []
    @Published private(set) var isLoaded: Bool = false

    private init() {
        load()
    }

    // MARK: - Loading

    private func load() {
        pairs = Self.decode([SentencePair].self, named: "corpus_tr_en") ?? []
        frequency = Self.decode([FrequencyEntry].self, named: "frequency_tr") ?? []
        isLoaded = true
    }

    private static func decode<T: Decodable>(_ type: T.Type, named name: String) -> T? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Queries

    /// Top `limit` sentence pairs whose Turkish side starts with `prefix`
    /// (Turkish-aware case-insensitive match).
    func searchSentences(matching query: String, limit: Int = 50) -> [SentencePair] {
        let needle = query.lowercased(with: Locale(identifier: "tr_TR"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return [] }
        var out: [SentencePair] = []
        for pair in pairs {
            let haystack = pair.tr.lowercased(with: Locale(identifier: "tr_TR"))
            if haystack.contains(needle) {
                out.append(pair)
                if out.count >= limit { break }
            }
        }
        return out
    }

    /// Frequency entries whose word starts with `prefix` (Turkish lowercase).
    func searchWords(prefix: String, limit: Int = 50) -> [FrequencyEntry] {
        let needle = prefix.lowercased(with: Locale(identifier: "tr_TR"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return [] }
        var out: [FrequencyEntry] = []
        for entry in frequency {
            let w = entry.word.lowercased(with: Locale(identifier: "tr_TR"))
            if w.hasPrefix(needle) {
                out.append(entry)
                if out.count >= limit { break }
            }
        }
        return out
    }

    /// Deterministic daily pick from the corpus — same sentence for the whole
    /// day, across app relaunches, without any network call.
    func dailySentence(for date: Date = .init()) -> SentencePair? {
        guard !pairs.isEmpty else { return nil }
        let key = ActivityDateKey.key(for: date)
        // Swift's Hasher uses a process-random seed, so we use a stable
        // djb2 hash to guarantee the same daily sentence across relaunches.
        var h: UInt64 = 5381
        for byte in key.utf8 { h = h &* 33 &+ UInt64(byte) }
        return pairs[Int(h % UInt64(pairs.count))]
    }

    /// Random sentence bucketed by length so A1 drills stay short while C1/C2
    /// challenges pick longer, more idiomatic sentences.
    func randomSentence(maxLength: Int = 60) -> SentencePair? {
        let bucket = pairs.filter { $0.len <= maxLength }
        return bucket.randomElement() ?? pairs.randomElement()
    }

    // MARK: - Stats

    var sentenceCount: Int { pairs.count }
    var wordCount: Int { frequency.count }

    var stats: String {
        let pairsK = Double(pairs.count) / 1000
        let wordsK = Double(frequency.count) / 1000
        return String(format: "%.1fk sentences · %.1fk words", pairsK, wordsK)
    }
}
