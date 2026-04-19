import SwiftUI

struct GradientBackground: View {
    var level: CEFRLevel? = nil

    var body: some View {
        ZStack {
            // Base material for vibrancy
            Rectangle().fill(.thinMaterial)

            // Soft radial tint derived from the level's accent color.
            GeometryReader { geo in
                let tint = (level?.accentColor ?? .accentColor).opacity(0.18)
                RadialGradient(
                    colors: [tint, .clear],
                    center: .topLeading,
                    startRadius: 10,
                    endRadius: max(geo.size.width, geo.size.height)
                )
                RadialGradient(
                    colors: [(level?.accentColor ?? .accentColor).opacity(0.10), .clear],
                    center: .bottomTrailing,
                    startRadius: 10,
                    endRadius: max(geo.size.width, geo.size.height) * 0.8
                )
            }
        }
        .ignoresSafeArea()
    }
}
