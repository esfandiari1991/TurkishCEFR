import SwiftUI

/// Word-by-word aligned view of a Turkish sentence. Directly addresses the
/// beginner's "I can't tell which English word matches which Turkish
/// word" complaint from the feedback list — every surface form, every
/// suffix feature, every English gloss sits in the same column.
struct InterlinearGlossView: View {
    @ObservedObject private var corpus = CorpusStore.shared

    @State private var input: String = ""
    @State private var tokens: [InterlinearGlosser.Token] = []
    @State private var translation: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            header
            entry
            result
            Spacer(minLength: 0)
        }
        .padding(Spacing.xl)
        .onAppear { seedExample() }
    }

    private var header: some View {
        HStack {
            Text("Interlinear gloss · Kelime kelime")
                .displayTitle()
            HelpBubble(
                """
                Paste any Turkish sentence and we line it up word-by-word with a rough \
                English gloss underneath each word, including a tag for every suffix \
                (ACC = accusative object, LOC = location, PL = plural, PAST.1S = past tense I, etc.). \
                This is the fastest way to see how Turkish builds meaning from suffixes.
                """,
                title: "What is interlinear gloss?"
            )
            Spacer()
            Button("Shuffle example") { seedExample() }
                .buttonStyle(.bordered)
        }
    }

    private var entry: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            TextField("Türkçe cümle yazın… (type a Turkish sentence)",
                      text: $input, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 18))
                .padding(Spacing.md)
                .background(RoundedRectangle(cornerRadius: 10).fill(.thinMaterial))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(BrandTheme.turquoise.opacity(0.45), lineWidth: 1))
                .onSubmit { analyse() }

            HStack {
                Button("Gloss") { analyse() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(BrandTheme.crimson)
                    .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)

                Button {
                    Speech.shared.speak(input)
                } label: {
                    Label("Play", systemImage: "play.circle.fill")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)

                if let translation {
                    Text(translation)
                        .font(.callout.italic())
                        .foregroundStyle(.secondary)
                        .padding(.leading, 8)
                }
            }
        }
    }

    @ViewBuilder
    private var result: some View {
        if tokens.isEmpty {
            EmptyStatePanel(
                systemImage: "textformat.size",
                headline: "Type a sentence above",
                message: "Try \"Bu kitap çok güzel.\" or press Shuffle to pick a random sentence from the offline library."
            )
            .frame(maxHeight: 280)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(tokens) { token in
                        column(for: token)
                    }
                }
                .padding(Spacing.md)
            }
            .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
        }
    }

    private func column(for token: InterlinearGlosser.Token) -> some View {
        VStack(spacing: 6) {
            Text(token.surface)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)
            if token.lemma != token.surface {
                Text(token.lemma)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
            Text(token.pos)
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(
                    Capsule().fill(BrandTheme.crimson.opacity(0.12))
                )
                .foregroundStyle(BrandTheme.crimson)
            if !token.features.isEmpty {
                Text(token.featuresLabel)
                    .font(.caption2.monospaced())
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(
                        Capsule().fill(BrandTheme.turquoise.opacity(0.15))
                    )
                    .foregroundStyle(BrandTheme.turquoise)
            }
            Text(token.english)
                .font(.callout.italic())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 96, alignment: .top)
        .padding(.vertical, 4)
    }

    // MARK: - Behaviour

    private func seedExample() {
        if let pair = corpus.randomSentence(maxLength: 60) {
            input = pair.tr
            translation = pair.en
            analyse()
        } else {
            input = "Bu kitap çok güzel."
            translation = "This book is very beautiful."
            analyse()
        }
    }

    private func analyse() {
        tokens = InterlinearGlosser.gloss(input)
    }
}
