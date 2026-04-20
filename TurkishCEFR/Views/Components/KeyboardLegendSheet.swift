import SwiftUI

/// A single table listing every keyboard shortcut the app understands,
/// grouped by category. Opened from the Help menu (⌘/) or from Settings →
/// Help. Nothing in this table is required to use the app — it's just an
/// inventory for power users.
struct KeyboardLegendSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ForEach(KeyboardShortcutGroup.all) { group in
                        group(for: group)
                    }
                }
                .padding(Spacing.xl)
            }
        }
        .frame(minWidth: 560, minHeight: 520)
        .background(.regularMaterial)
    }

    private var header: some View {
        HStack(alignment: .center) {
            Label("Keyboard shortcuts", systemImage: "keyboard.fill")
                .font(.title2.weight(.bold))
            Spacer()
            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                .tint(BrandTheme.crimson)
        }
        .padding(Spacing.lg)
    }

    private func group(for g: KeyboardShortcutGroup) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label(g.title, systemImage: g.systemImage)
                .font(.headline)
                .foregroundStyle(g.tint)
            VStack(alignment: .leading, spacing: 0) {
                ForEach(g.entries) { e in
                    HStack(alignment: .top) {
                        ShortcutKey(keys: e.keys)
                        Text(e.description)
                            .font(DisplayFont.body)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 6)
                    Divider()
                }
            }
        }
    }
}

struct KeyboardShortcutGroup: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let tint: Color
    let entries: [Entry]

    struct Entry: Identifiable {
        let id = UUID()
        let keys: [String]
        let description: String
    }

    static let all: [KeyboardShortcutGroup] = [
        .init(title: "Navigation", systemImage: "arrow.left.arrow.right",
              tint: BrandTheme.turquoise, entries: [
                .init(keys: ["⌘", "F"],
                      description: "Open the lesson search palette (find any lesson by name)."),
                .init(keys: ["⌘", "D"],
                      description: "Open the Stats dashboard."),
                .init(keys: ["Esc"],
                      description: "Close any open sheet or popover."),
              ]),
        .init(title: "Learning", systemImage: "book.fill",
              tint: BrandTheme.crimson, entries: [
                .init(keys: ["Space"],
                      description: "Play audio of the focused Turkish text."),
                .init(keys: ["⌘", "."],
                      description: "Stop any in-flight speech immediately."),
                .init(keys: ["⌘", "⇧", "R"],
                      description: "Reset progress for the current level (with confirmation)."),
              ]),
        .init(title: "Tools", systemImage: "wrench.and.screwdriver.fill",
              tint: BrandTheme.gold, entries: [
                .init(keys: ["Enter"],
                      description: "Submit your answer in any exercise."),
                .init(keys: ["←", "→"],
                      description: "Flip flash cards / step through dialogue lines."),
              ]),
        .init(title: "Help", systemImage: "questionmark.circle.fill",
              tint: .purple, entries: [
                .init(keys: ["⌘", "/"],
                      description: "Open this keyboard legend."),
                .init(keys: ["⌘", ","],
                      description: "Open Settings."),
              ]),
    ]
}

private struct ShortcutKey: View {
    let keys: [String]
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(keys.enumerated()), id: \.offset) { i, k in
                Text(k)
                    .font(.system(.body, design: .monospaced).weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.quaternary)
                            )
                    )
                if i < keys.count - 1 {
                    Text("+")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(minWidth: 120, alignment: .leading)
    }
}
