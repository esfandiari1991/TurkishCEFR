import SwiftUI

/// Re-usable empty-state panel shown whenever a view has no content to
/// display. Centers an icon + friendly headline + short explanation + one
/// large primary action button. The action button is labelled in plain
/// English and never requires a keyboard shortcut.
///
/// This fixes a common UX pitfall: a blank screen that tells the user to
/// "press ⌘F to search". That's fine for power users but completely
/// opaque to a first-time Mac learner. With `EmptyStatePanel`, every
/// empty screen shows a button you can click.
struct EmptyStatePanel<Action: View>: View {
    let systemImage: String
    let headline: String
    let message: String
    let tint: Color
    let action: () -> Action

    init(systemImage: String,
         headline: String,
         message: String,
         tint: Color = BrandTheme.turquoise,
         @ViewBuilder action: @escaping () -> Action = { EmptyView() }) {
        self.systemImage = systemImage
        self.headline = headline
        self.message = message
        self.tint = tint
        self.action = action
    }

    var body: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.14))
                    .frame(width: 96, height: 96)
                Image(systemName: systemImage)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(tint)
            }
            Text(headline)
                .displayTitle()
                .multilineTextAlignment(.center)
            Text(message)
                .font(DisplayFont.body)
                .foregroundStyle(.secondary)
                .lineSpacing(LineHeight.body)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 520)
            action()
                .controlSize(.large)
                .padding(.top, Spacing.xs)
        }
        .padding(Spacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
