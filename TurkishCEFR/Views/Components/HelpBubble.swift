import SwiftUI

/// A small "?" icon that, when hovered or clicked, pops up a friendly
/// plain-English explanation for whatever control it sits next to. This is
/// the single most important beginner-affordance in the app: anywhere a
/// learner might hesitate ("what does this button do?"), we attach a
/// `HelpBubble` so the answer is one click away.
///
/// Usage:
///
///     HStack {
///         Button("Start lesson") { ... }
///         HelpBubble("Opens the first section of this lesson. You can come back any time.")
///     }
///
/// The bubble renders the same on light and dark mode, is keyboard
/// focusable, and its popover is accessible to VoiceOver.
struct HelpBubble: View {
    let text: String
    var title: String?

    @State private var showing = false

    init(_ text: String, title: String? = nil) {
        self.text = text
        self.title = title
    }

    var body: some View {
        Button {
            showing.toggle()
        } label: {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: IconSize.body, weight: .regular))
                .foregroundStyle(.secondary)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help(text)
        .popover(isPresented: $showing, arrowEdge: .top) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                if let title {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(BrandTheme.crimson)
                }
                Text(text)
                    .font(DisplayFont.body)
                    .lineSpacing(LineHeight.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.md)
            .frame(maxWidth: 320, alignment: .leading)
        }
        .accessibilityLabel(Text(title ?? "Help"))
        .accessibilityHint(Text(text))
    }
}
