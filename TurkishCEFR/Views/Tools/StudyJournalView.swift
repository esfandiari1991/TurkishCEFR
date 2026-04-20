import SwiftUI

/// Pane listing every day of study with XP, lessons touched, new words,
/// and a user-editable note. Replaces the old empty "Stats" tab for
/// learners who want a timeline view instead of a bar chart.
struct StudyJournalView: View {
    @ObservedObject private var store = StudyJournalStore.shared
    @State private var selection: StudyJournalStore.Entry?

    var body: some View {
        HSplitView {
            list
                .frame(minWidth: 260, idealWidth: 320, maxWidth: 420)
            detail
                .frame(minWidth: 400)
        }
        .onAppear {
            selection = store.sortedEntries.first
        }
    }

    // MARK: - List

    private var list: some View {
        Group {
            if store.entries.isEmpty {
                EmptyStatePanel(
                    systemImage: "book.closed.fill",
                    headline: "Your Study Journal is empty",
                    message: "Every day you open the app and touch a lesson, a journal entry is created automatically. Come back tomorrow to see your first streak."
                ) {
                    EmptyView()
                }
            } else {
                List(store.sortedEntries, selection: $selection) { entry in
                    row(for: entry)
                        .tag(entry)
                        .padding(.vertical, 4)
                }
                .listStyle(.inset)
            }
        }
    }

    private func row(for entry: StudyJournalStore.Entry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.date, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                SoftPill(text: "+\(entry.xpEarned) XP", tint: BrandTheme.gold)
            }
            HStack(spacing: 12) {
                Label("\(entry.lessonTitles.count)", systemImage: "book.fill")
                Label("\(entry.wordsMastered.count)", systemImage: "character.book.closed.fill")
                Label("\(entry.grammarStudied.count)", systemImage: "textformat.alt")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Detail

    @ViewBuilder
    private var detail: some View {
        if let entry = selection {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text(entry.date, format: .dateTime.weekday(.wide).month().day().year())
                        .displayTitle()

                    HStack(spacing: Spacing.md) {
                        statChip("+\(entry.xpEarned) XP", color: BrandTheme.gold)
                        statChip("\(entry.lessonTitles.count) lessons", color: BrandTheme.crimson)
                        statChip("\(entry.wordsMastered.count) new words", color: BrandTheme.turquoise)
                        statChip("\(entry.grammarStudied.count) grammar", color: .purple)
                    }

                    if !entry.lessonTitles.isEmpty {
                        section("Lessons you worked on", items: entry.lessonTitles)
                    }
                    if !entry.wordsMastered.isEmpty {
                        section("Words mastered", items: entry.wordsMastered)
                    }
                    if !entry.grammarStudied.isEmpty {
                        section("Grammar you studied", items: entry.grammarStudied)
                    }

                    note(for: entry)
                }
                .padding(Spacing.xl)
            }
        } else {
            EmptyStatePanel(
                systemImage: "calendar",
                headline: "Pick a day",
                message: "Choose a day on the left to see what you studied, or come back tomorrow to start your streak."
            )
        }
    }

    private func statChip(_ label: String, color: Color) -> some View {
        Text(label)
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(
                Capsule().fill(color.opacity(0.15))
            )
            .overlay(Capsule().stroke(color.opacity(0.4), lineWidth: 1))
            .foregroundStyle(color)
    }

    private func section(_ title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title).font(.headline)
            FlowLayout(spacing: 6) {
                ForEach(items, id: \.self) { item in
                    SoftPill(text: item, tint: BrandTheme.turquoise)
                }
            }
        }
    }

    @ViewBuilder
    private func note(for entry: StudyJournalStore.Entry) -> some View {
        // Route the binding through the live store by day key. Earlier
        // versions read `entry.note` from the captured @State selection,
        // which was a struct copy and went stale on every published
        // update — so typing a keystroke triggered save → re-render →
        // revert. Looking the entry up by its immutable day key each
        // render always reads the current value.
        JournalNoteEditor(dayKey: entry.dayKey)
    }
}

/// Isolated sub-view that owns its own bind-to-store state so editing
/// the note feels instantaneous without losing characters to a
/// save/render cycle.
private struct JournalNoteEditor: View {
    let dayKey: String
    @ObservedObject private var store = StudyJournalStore.shared

    private var currentNote: String {
        store.entries.first(where: { $0.dayKey == dayKey })?.note ?? ""
    }

    var body: some View {
        let binding = Binding<String>(
            get: { currentNote },
            set: { newValue in
                if let date = ISO8601DateFormatter.dayKeyFormatter.date(from: dayKey) {
                    store.setNote(newValue, for: date)
                }
            }
        )
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Text("Your note")
                    .font(.headline)
                HelpBubble("Jot down anything you want to remember — a tricky suffix, a new word, a goal for tomorrow. Your notes stay private on your Mac.")
            }
            TextEditor(text: binding)
                .font(DisplayFont.body)
                .lineSpacing(LineHeight.body)
                .frame(minHeight: 120)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.thinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

/// Lightweight flow layout for chips. Wraps onto multiple lines.
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
