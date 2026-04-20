import SwiftUI

/// Dictation drill: the app plays a Turkish sentence, the learner types
/// what they heard, and we give character-level feedback highlighting
/// exactly where they diverged from the target. Inspired by the Olle
/// Kjellin "pronunciation loop" technique: listen → reproduce → compare.
///
/// The sentence pool is drawn from `CorpusStore.pairs` so everything runs
/// fully offline. Users who install Yelda get near-native playback.
struct DictationView: View {
    @ObservedObject private var corpus = CorpusStore.shared
    @ObservedObject private var speech = Speech.shared

    @State private var pair: CorpusStore.SentencePair?
    @State private var typed: String = ""
    @State private var checked: Bool = false
    @State private var revealed: Bool = false
    @State private var playsToday: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            header

            if corpus.sentenceCount == 0 {
                EmptyStatePanel(
                    systemImage: "waveform.slash",
                    headline: "No sentences loaded yet",
                    message: "The offline corpus is still warming up in the background. Come back in a few seconds — it only loads once per launch."
                ) {
                    Button("Retry") { pair = corpus.randomSentence(maxLength: 80) }
                        .buttonStyle(.borderedProminent)
                        .tint(BrandTheme.crimson)
                }
            } else {
                card
            }

            Spacer(minLength: 0)
        }
        .padding(Spacing.xl)
        .onAppear {
            if pair == nil { pickSentence(maxLen: 80) }
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Dictation · Yazım egzersizi")
                .displayTitle()
            HelpBubble(
                """
                Click Play, listen carefully, then type what you heard in Turkish. \
                We compare letter-by-letter so you can see exactly where you went wrong — \
                even if you only missed a vowel harmony or a missing dot on an i.
                """,
                title: "What is Dictation?"
            )
            Spacer()
            Button {
                pickSentence(maxLen: 80)
            } label: {
                Label("New sentence", systemImage: "dice.fill")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .disabled(corpus.sentenceCount == 0)
        }
    }

    @ViewBuilder
    private var card: some View {
        if let pair {
            SectionCard(title: "Listen & type",
                        systemImage: "ear.and.waveform",
                        tint: BrandTheme.turquoise) {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack(spacing: Spacing.md) {
                        Button {
                            Speech.shared.speak(pair.tr)
                            playsToday += 1
                        } label: {
                            Label(playsToday == 0 ? "Play audio"
                                                  : "Play again (\(playsToday))",
                                  systemImage: "play.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(BrandTheme.crimson)
                        // Command-modifier is required: the space bar alone
                        // would otherwise be swallowed before the TextField
                        // below can receive it, making multi-word dictation
                        // answers impossible to type.
                        .keyboardShortcut(.space, modifiers: .command)

                        Button {
                            Speech.shared.speak(pair.tr, rate: 0.35)
                            playsToday += 1
                        } label: {
                            Label("Play slowly", systemImage: "tortoise.fill")
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        Spacer()

                        if speech.isSpeaking {
                            ProgressView().controlSize(.small)
                            Text("Speaking…")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    TextField("Type what you heard…", text: $typed, axis: .vertical)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .regular))
                        .padding(Spacing.md)
                        .frame(minHeight: 80, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.thinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(BrandTheme.turquoise.opacity(0.5), lineWidth: 1)
                        )
                        .onSubmit { checked = true }

                    HStack {
                        Button("Check") { checked = true }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(BrandTheme.crimson)
                            .keyboardShortcut(.return, modifiers: [])
                            .disabled(typed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        Button("Reveal answer") {
                            // Tell `feedback(target:)` this was an intentional
                            // reveal, not a failed attempt — otherwise we would
                            // show "Close — compare below" and 0% accuracy
                            // even though the learner never tried.
                            revealed = true
                            checked = true
                        }
                            .buttonStyle(.bordered)
                            .controlSize(.large)

                        Spacer()

                        Text(pair.en)
                            .font(.callout.italic())
                            .foregroundStyle(.secondary)
                            .opacity(checked ? 1 : 0)
                            .animation(.easeInOut, value: checked)
                    }

                    if checked {
                        feedback(target: pair.tr)
                    }
                }
            }
        }
    }

    // MARK: - Feedback

    /// Highlight every character of the target: green where it matches the
    /// learner's input, red where it doesn't. We use Myers' diff-style
    /// char-by-char comparison with Turkish-aware lowercasing so an ı vs i
    /// typo is highlighted correctly.
    private func feedback(target: String) -> some View {
        let comparator = compare(
            target: target.lowercased(with: Locale(identifier: "tr_TR")),
            got: typed.lowercased(with: Locale(identifier: "tr_TR"))
        )
        let headline: String
        let headlineColor: Color
        if revealed {
            headline = "Answer revealed · Cevap gösterildi"
            headlineColor = BrandTheme.turquoise
        } else if comparator.exact {
            headline = "Perfect! · Mükemmel!"
            headlineColor = .green
        } else {
            headline = "Close — compare below"
            headlineColor = .orange
        }
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(headline)
                .font(.headline)
                .foregroundStyle(headlineColor)
            // Colored reconstruction of target. In reveal mode we paint every
            // character green because the intent is "show me the answer", not
            // "grade my attempt".
            FlowLayout(spacing: 0) {
                ForEach(Array(target.enumerated()), id: \.offset) { i, ch in
                    Text(String(ch))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(colorForChar(at: i, marks: comparator.marks))
                }
            }
            if !revealed && comparator.similarity < 1 {
                Text(String(format: "Accuracy: %d%%", Int(comparator.similarity * 100)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
    }

    private struct ComparisonResult {
        let marks: [Bool]      // per-char correctness
        let exact: Bool
        let similarity: Double
    }

    private func colorForChar(at i: Int, marks: [Bool]) -> Color {
        if revealed { return .green }
        if i < marks.count { return marks[i] ? .green : .red }
        return .primary
    }

    private func compare(target: String, got: String) -> ComparisonResult {
        let t = Array(target)
        let g = Array(got)
        var marks = [Bool](repeating: false, count: t.count)
        var hits = 0
        for (i, c) in t.enumerated() where i < g.count {
            if g[i] == c {
                marks[i] = true
                hits += 1
            }
        }
        let total = max(t.count, 1)
        return ComparisonResult(
            marks: marks,
            exact: t == g,
            similarity: Double(hits) / Double(total)
        )
    }

    private func pickSentence(maxLen: Int) {
        pair = corpus.randomSentence(maxLength: maxLen)
        typed = ""
        checked = false
        revealed = false
        playsToday = 0
    }
}
