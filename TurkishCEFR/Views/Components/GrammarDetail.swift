import SwiftUI

/// Rich grammar renderer — shows intro, rules, patterns, examples, pitfalls, summary.
/// Automatically marks the note as "studied" the first time it appears on screen.
struct GrammarDetailView: View {
    @EnvironmentObject private var progress: ProgressStore
    let lessonID: String
    let note: GrammarNote
    let tint: Color

    @State private var expanded: Bool

    init(lessonID: String, note: GrammarNote, tint: Color) {
        self.lessonID = lessonID
        self.note = note
        self.tint = tint
        _expanded = State(initialValue: !(note.hasRichDetail))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            if expanded { expanded_body }
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.05)))
        .onAppear {
            progress.markGrammarStudied(lessonID: lessonID, title: note.title)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: expanded)
    }

    private var header: some View {
        HStack(alignment: .top) {
            Text(note.title).font(.headline)
            Spacer()
            if note.hasRichDetail {
                Button {
                    expanded.toggle()
                } label: {
                    Image(systemName: expanded ? "chevron.up.circle.fill" : "chevron.down.circle")
                        .foregroundStyle(tint)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var expanded_body: some View {
        if let intro = note.intro {
            Text(intro).font(.body).foregroundStyle(.primary.opacity(0.9))
        } else {
            Text(note.explanation).font(.body).foregroundStyle(.primary.opacity(0.9))
        }

        if !note.rules.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Label("Formation rules", systemImage: "function")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(note.rules) { r in
                        HStack(alignment: .top, spacing: 10) {
                            Text(r.label)
                                .font(.callout.weight(.medium))
                                .frame(minWidth: 140, alignment: .leading)
                            Text(r.formula)
                                .font(.callout.monospaced())
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
                            if let note = r.note {
                                Text(note).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(10)
            .background(tint.opacity(0.06), in: RoundedRectangle(cornerRadius: 10))
        }

        if !note.patterns.isEmpty {
            ForEach(note.patterns) { p in
                VStack(alignment: .leading, spacing: 4) {
                    Text(p.heading).font(.subheadline.weight(.semibold))
                    Text(p.body).font(.callout).foregroundStyle(.primary.opacity(0.85))
                    if !p.examples.isEmpty {
                        ExampleBlock(examples: p.examples, tint: tint)
                    }
                }
                .padding(.top, 4)
            }
        }

        if !note.examples.isEmpty {
            ExampleBlock(examples: note.examples, tint: tint)
        }

        if !note.pitfalls.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Label("Common pitfalls", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                ForEach(note.pitfalls, id: \.self) { p in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•").foregroundStyle(.orange)
                        Text(p).font(.callout).foregroundStyle(.primary.opacity(0.85))
                    }
                }
            }
            .padding(10)
            .background(Color.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
        }

        if let summary = note.summary {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill").foregroundStyle(tint)
                Text(summary).font(.callout.weight(.medium))
            }
            .padding(10)
            .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

private struct ExampleBlock: View {
    let examples: [Phrase]
    let tint: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(examples, id: \.self) { ex in
                HStack(alignment: .top, spacing: 10) {
                    PronunciationButton(text: ex.turkish, tint: tint)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ex.turkish).font(.callout.weight(.medium))
                        Text(ex.english).font(.caption).foregroundStyle(.secondary)
                        if let note = ex.note {
                            Text(note).font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(10)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 10))
    }
}
