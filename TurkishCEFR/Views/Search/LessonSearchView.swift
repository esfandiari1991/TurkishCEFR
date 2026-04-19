import SwiftUI

/// Command-palette style lesson search. Matches against title (TR/EN), summary,
/// CEFR level, and vocabulary words. Use ⌘F to invoke.
struct LessonSearchView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedLevel: CEFRLevel?
    @Binding var selectedLesson: Lesson?

    @State private var query: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            results
        }
        .frame(width: 680, height: 520)
        .onAppear { focused = true }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.secondary)
            TextField("Search lessons, words, grammar…", text: $query)
                .focused($focused)
                .textFieldStyle(.plain)
                .font(.title3)
                .onSubmit { openFirstMatch() }
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            Button("Close") { dismiss() }
                .keyboardShortcut(.cancelAction)
        }
        .padding(14)
    }

    private var results: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 6) {
                if matches.isEmpty {
                    ContentUnavailableView(
                        query.isEmpty ? "Start typing to search"
                                      : "No lessons match “\(query)”",
                        systemImage: "magnifyingglass",
                        description: Text("Search across titles, summaries, vocabulary, and grammar.")
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(matches, id: \.lesson.id) { result in
                        Button {
                            open(result.lesson)
                        } label: {
                            ResultRow(result: result)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(10)
        }
    }

    // MARK: - Matching

    struct SearchResult: Hashable {
        let lesson: Lesson
        let reason: String
    }

    private var matches: [SearchResult] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        let needle = trimmed.lowercased(with: Locale(identifier: "tr_TR"))
        var out: [SearchResult] = []
        for lesson in curriculum.allLessons {
            let base = [
                lesson.titleTR, lesson.titleEN, lesson.summary,
                "\(lesson.level.rawValue) \(lesson.level.title) \(lesson.level.englishTitle)"
            ].joined(separator: " ").lowercased(with: Locale(identifier: "tr_TR"))
            if base.contains(needle) {
                out.append(SearchResult(lesson: lesson,
                                        reason: lesson.level.rawValue + " · " + lesson.titleEN))
                continue
            }
            if let vocab = lesson.vocabulary.first(where: {
                $0.turkish.lowercased(with: Locale(identifier: "tr_TR")).contains(needle)
                || $0.english.lowercased().contains(needle)
            }) {
                out.append(SearchResult(lesson: lesson,
                                        reason: "word · \(vocab.turkish) → \(vocab.english)"))
                continue
            }
            if let gram = lesson.grammar.first(where: {
                $0.title.lowercased().contains(needle)
            }) {
                out.append(SearchResult(lesson: lesson, reason: "grammar · \(gram.title)"))
            }
        }
        return Array(out.prefix(60))
    }

    private func openFirstMatch() {
        if let first = matches.first {
            open(first.lesson)
        }
    }

    private func open(_ lesson: Lesson) {
        selectedLevel = lesson.level
        selectedLesson = lesson
        dismiss()
    }

    private struct ResultRow: View {
        let result: SearchResult
        var body: some View {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(result.lesson.level.gradient)
                        .frame(width: 40, height: 40)
                    Image(systemName: result.lesson.systemImage)
                        .foregroundStyle(.white)
                        .font(.title3)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(result.lesson.titleTR).font(.system(size: 15, weight: .semibold))
                    Text(result.lesson.titleEN).font(.caption).foregroundStyle(.secondary)
                    Text(result.reason).font(.caption2).foregroundStyle(.tertiary)
                }
                Spacer()
                SoftPill(text: result.lesson.level.rawValue,
                         tint: result.lesson.level.accentColor)
            }
            .padding(10)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
    }
}
