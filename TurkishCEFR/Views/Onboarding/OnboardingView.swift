import SwiftUI

/// Full-screen, translucent, spring-animated onboarding overlay. Presented
/// on first launch (and whenever the user picks "Restart tour" from
/// Settings → Help). Every control is large, labelled, clickable by mouse —
/// no keyboard shortcut is required to complete the tour.
struct OnboardingView: View {
    @ObservedObject private var store = OnboardingStore.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.55))
                .ignoresSafeArea()
                .allowsHitTesting(true)

            card
                .frame(maxWidth: 640)
                .padding(Spacing.xl)
                .background(.ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 30, y: 8)
                .transition(.scale(scale: 0.96).combined(with: .opacity))
                .accessibilityElement(children: .contain)
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.82),
                   value: store.step)
    }

    @ViewBuilder
    private var card: some View {
        let step = store.currentStep
        VStack(alignment: .leading, spacing: Spacing.lg) {
            header(step)
            Text(step.headline)
                .font(DisplayFont.body)
                .lineSpacing(LineHeight.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            stepDots

            HStack(spacing: Spacing.md) {
                Button("Skip tour") { store.skip() }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .help("Close the tour — you can always reopen it from Settings")

                Spacer(minLength: 0)

                if store.step > 0 {
                    Button("Back") { store.back() }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }
                Button(step.primaryActionLabel) { store.advance() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.defaultAction)
                    .tint(BrandTheme.crimson)
            }
        }
        .padding(Spacing.xl)
    }

    private func header(_ step: OnboardingStep) -> some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [BrandTheme.crimson, BrandTheme.turquoise],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                Image(systemName: step.systemImage)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .shadow(color: .black.opacity(0.25), radius: 8, y: 3)

            VStack(alignment: .leading, spacing: 4) {
                Text("Step \(store.step + 1) of \(OnboardingStep.allCases.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(step.title)
                    .displayTitle()
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
    }

    private var stepDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<OnboardingStep.allCases.count, id: \.self) { i in
                Capsule()
                    .fill(i == store.step
                          ? BrandTheme.crimson
                          : Color.secondary.opacity(0.25))
                    .frame(width: i == store.step ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.4,
                                       dampingFraction: 0.8),
                               value: store.step)
            }
        }
    }
}
