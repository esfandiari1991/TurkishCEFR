import SwiftUI

/// Expandable vocabulary card. When a word has rich metadata (definition,
/// synonyms, more examples, usage note, etymology) it shows a disclosure
/// toggle that reveals a detailed study panel.
struct VocabCard: View {
    let item: VocabularyItem
    let mastered: Bool
    let tint: Color
    let onToggle: () -> Void

    @State private var expanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            if expanded { details.padding(.top, 10) }
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.06)))
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: expanded)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(item.turkish)
                        .font(.system(size: 16, weight: .semibold))
                    Text(item.partOfSpeech.label)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 1)
                        .background(tint.opacity(0.15), in: Capsule())
                        .foregroundStyle(tint)
                    if let ipa = item.ipa {
                        Text("[\(ipa)]").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                Text(item.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let tr = item.exampleTR, let en = item.exampleEN, !expanded {
                    Text("“\(tr)” — \(en)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .padding(.top, 2)
                }
            }
            Spacer()
            VStack(spacing: 8) {
                Button(action: onToggle) {
                    Image(systemName: mastered ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(mastered ? tint : .secondary)
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .help(mastered ? "Mastered — click to unset" : "Mark as mastered")
                PronunciationButton(text: item.turkish, tint: tint)
                if item.hasRichDetail {
                    Button {
                        expanded.toggle()
                    } label: {
                        Image(systemName: expanded ? "chevron.up.circle.fill" : "info.circle")
                            .foregroundStyle(tint)
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                    .help("More detail")
                }
            }
        }
    }

    @ViewBuilder
    private var details: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let def = item.definitionEN {
                DefinitionBlock(title: "Definition", text: def, tint: tint)
            }
            if let defTR = item.definitionTR {
                DefinitionBlock(title: "Tanım (TR)", text: defTR, tint: tint)
            }
            if !item.moreExamples.isEmpty || item.exampleTR != nil {
                examplesBlock
            }
            if !item.synonyms.isEmpty {
                ChipsBlock(title: "Synonyms · Eş Anlamlı", items: item.synonyms, tint: tint)
            }
            if !item.antonyms.isEmpty {
                ChipsBlock(title: "Antonyms · Zıt Anlamlı", items: item.antonyms, tint: .red)
            }
            if let note = item.usageNote {
                DefinitionBlock(title: "Usage note", text: note, tint: tint, icon: "lightbulb")
            }
            if let etym = item.etymology {
                DefinitionBlock(title: "Etymology", text: etym, tint: tint, icon: "clock.arrow.circlepath")
            }
        }
        .padding(10)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 10))
    }

    @ViewBuilder
    private var examplesBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Examples · Örnekler")
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)
            if let tr = item.exampleTR, let en = item.exampleEN {
                ExampleRow(tr: tr, en: en, tint: tint)
            }
            ForEach(item.moreExamples, id: \.self) { ex in
                ExampleRow(tr: ex.turkish, en: ex.english, tint: tint)
            }
        }
    }
}

private struct ExampleRow: View {
    let tr: String
    let en: String
    let tint: Color
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            PronunciationButton(text: tr, tint: tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(tr).font(.callout)
                Text(en).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

private struct DefinitionBlock: View {
    let title: String
    let text: String
    let tint: Color
    var icon: String = "text.alignleft"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon).foregroundStyle(tint)
                Text(title).font(.caption.weight(.semibold)).foregroundStyle(tint)
            }
            Text(text).font(.callout)
        }
    }
}

private struct ChipsBlock: View {
    let title: String
    let items: [String]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption.weight(.semibold)).foregroundStyle(tint)
            FlowLayout(spacing: 6) {
                ForEach(items, id: \.self) { s in
                    Text(s)
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(tint.opacity(0.12), in: Capsule())
                        .foregroundStyle(tint)
                }
            }
        }
    }
}

/// Simple horizontal wrapping flow layout (macOS 14+).
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for s in subviews {
            let size = s.sizeThatFits(.unspecified)
            if x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth.isFinite ? maxWidth : x, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize,
                       subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        for s in subviews {
            let size = s.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            s.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
