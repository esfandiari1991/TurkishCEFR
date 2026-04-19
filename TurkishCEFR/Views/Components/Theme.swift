import SwiftUI

/// Brand tokens for TurkishCEFR — Turkish-inspired palette: crimson flag red,
/// Bosphorus turquoise, and Ottoman gold. Tokens are resolved through SwiftUI's
/// dynamic color system so they adapt to light/dark automatically.
enum BrandTheme {
    static let crimson   = Color(red: 0.89, green: 0.13, blue: 0.22)   // Türk bayrağı kırmızısı
    static let turquoise = Color(red: 0.00, green: 0.67, blue: 0.75)   // Boğaz turkuaz
    static let gold      = Color(red: 1.00, green: 0.78, blue: 0.20)   // Osmanlı altın
    static let navy      = Color(red: 0.08, green: 0.12, blue: 0.26)   // İstanbul gecesi
    static let ivory     = Color(red: 0.98, green: 0.96, blue: 0.92)

    static let primaryGradient = LinearGradient(
        colors: [crimson, Color(red: 0.98, green: 0.32, blue: 0.30)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let wealthGradient = LinearGradient(
        colors: [gold, Color(red: 0.98, green: 0.56, blue: 0.18)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let bosphorusGradient = LinearGradient(
        colors: [turquoise, Color(red: 0.20, green: 0.50, blue: 0.85)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let appBackground = LinearGradient(
        colors: [
            Color(red: 0.96, green: 0.92, blue: 0.88),
            Color(red: 0.88, green: 0.93, blue: 0.96)
        ],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let darkAppBackground = LinearGradient(
        colors: [
            Color(red: 0.07, green: 0.09, blue: 0.15),
            Color(red: 0.12, green: 0.14, blue: 0.22)
        ],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

/// A glassmorphic container that stacks an ultra-thin material, a brand tint
/// wash, and a hairline border for an Apple-style translucent look.
struct GlassCard<Content: View>: View {
    var tint: Color = BrandTheme.turquoise
    var cornerRadius: CGFloat = 18
    var padding: CGFloat = 18
    var intensity: Double = 0.10
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(tint.opacity(intensity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 18, y: 8)
    }
}

/// A premium section header used across the app for consistent hierarchy.
struct SectionHeader: View {
    let title: String
    let systemImage: String
    let tint: Color
    var subtitle: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.18))
                    .frame(width: 34, height: 34)
                Image(systemName: systemImage)
                    .foregroundStyle(tint)
                    .font(.system(size: 15, weight: .semibold))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

/// Standard section card used all over the app: glass background with a
/// sensible header and inline content slot.
struct SectionCard<Content: View>: View {
    let title: String
    let systemImage: String
    let tint: Color
    var subtitle: String? = nil
    @ViewBuilder var content: () -> Content

    var body: some View {
        GlassCard(tint: tint, cornerRadius: 20, padding: 20, intensity: 0.08) {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: title, systemImage: systemImage,
                              tint: tint, subtitle: subtitle)
                content()
            }
        }
    }
}

/// A soft, animated pill used for chips throughout the app.
struct SoftPill: View {
    let text: String
    var tint: Color = BrandTheme.turquoise
    var systemImage: String? = nil
    var body: some View {
        HStack(spacing: 4) {
            if let systemImage { Image(systemName: systemImage) }
            Text(text)
        }
        .font(.caption.weight(.semibold))
        .padding(.horizontal, 9).padding(.vertical, 3)
        .background(tint.opacity(0.18), in: Capsule())
        .foregroundStyle(tint)
    }
}

/// Hover-reactive shimmer background used on cards — subtle diagonal gleam.
struct ShimmerLine: View {
    @State private var phase: CGFloat = -1
    let tint: Color
    var body: some View {
        GeometryReader { geo in
            LinearGradient(
                colors: [.clear, tint.opacity(0.25), .clear],
                startPoint: .leading, endPoint: .trailing
            )
            .frame(width: geo.size.width * 0.4)
            .offset(x: geo.size.width * phase)
            .blendMode(.plusLighter)
        }
        .onAppear {
            withAnimation(.linear(duration: 3.6).repeatForever(autoreverses: false)) {
                phase = 1.4
            }
        }
        .allowsHitTesting(false)
    }
}
