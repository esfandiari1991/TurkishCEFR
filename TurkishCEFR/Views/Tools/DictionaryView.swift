import SwiftUI

/// Offline Turkish dictionary view. Searches the bundled frequency list
/// (top 10 000 words) and Tatoeba sentence pairs for both word and
/// sentence-level look-ups. Fully offline, ≈ 2.5 MB bundled data.
struct DictionaryView: View {
    @StateObject private var corpus = CorpusStore.shared
    @State private var query: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
        }
        .frame(minWidth: 520, minHeight: 420)
        .onAppear { focused = true }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search Turkish words & sentences…", text: $query)
                .textFieldStyle(.plain)
                .font(.title3)
                .focused($focused)
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.regularMaterial)
    }

    @ViewBuilder
    private var content: some View {
        if !corpus.isLoaded {
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if query.isEmpty {
            emptyState
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    wordSection
                    sentenceSection
                }
                .padding(22)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 42))
                .foregroundStyle(BrandTheme.turquoise.gradient)
            Text("Offline Turkish corpus")
                .font(.title3.weight(.semibold))
            Text(corpus.stats)
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("Start typing to search words from OpenSubtitles frequency data and sentences from Tatoeba (CC-BY 2.0 FR).")
                .multilineTextAlignment(.center)
                .frame(maxWidth: 420)
                .foregroundStyle(.secondary)
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }

    private var wordSection: some View {
        let words = corpus.searchWords(prefix: query, limit: 25)
        return Group {
            if !words.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Words (\(words.count))", systemImage: "text.alignleft")
                        .font(.headline)
                    LazyVStack(alignment: .leading, spacing: 6) {
                        ForEach(words) { w in
                            HStack(alignment: .firstTextBaseline) {
                                Text(w.word)
                                    .font(.body.weight(.semibold))
                                Spacer()
                                Text("#\(w.rank)")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                                Button {
                                    Speech.shared.speak(w.word)
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                }
                                .buttonStyle(.borderless)
                                .help("Pronounce")
                            }
                            .padding(.vertical, 4)
                            Divider().opacity(0.3)
                        }
                    }
                }
            }
        }
    }

    private var sentenceSection: some View {
        let sentences = corpus.searchSentences(matching: query, limit: 40)
        return Group {
            if !sentences.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Sentences (\(sentences.count))", systemImage: "quote.bubble")
                        .font(.headline)
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(sentences) { p in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(p.tr)
                                        .font(.body.weight(.semibold))
                                    Spacer()
                                    Button {
                                        Speech.shared.speak(p.tr)
                                    } label: {
                                        Image(systemName: "speaker.wave.2.fill")
                                    }
                                    .buttonStyle(.borderless)
                                }
                                Text(p.en)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                            Divider().opacity(0.3)
                        }
                    }
                }
            }
        }
    }
}
