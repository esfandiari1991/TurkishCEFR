import SwiftUI

/// Lightweight spring-based confetti celebration. Animates 80 colourful
/// particles falling from the top of the frame. The view removes itself
/// after the animation completes, so it's safe to drop into any overlay.
struct ConfettiView: View {
    let isActive: Bool
    var onFinish: () -> Void = {}

    private static let palette: [Color] = [
        BrandTheme.crimson, BrandTheme.turquoise, BrandTheme.gold,
        .white, .pink, Color(red: 0.60, green: 0.85, blue: 0.45)
    ]

    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    ConfettiPieceView(particle: p, size: geo.size)
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isActive) { _, _ in
            burst()
        }
    }

    private func burst() {
        particles = (0..<90).map { i in
            ConfettiParticle(
                id: UUID(),
                seed: i,
                color: Self.palette.randomElement() ?? .yellow,
                angle: Double.random(in: -0.4...0.4),
                rotation: Double.random(in: 0...360),
                fall: Double.random(in: 220...620),
                drift: Double.random(in: -160...160),
                delay: Double.random(in: 0...0.15),
                duration: Double.random(in: 1.6...2.6),
                shape: ConfettiShape.allCases.randomElement() ?? .rectangle
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            particles = []
            onFinish()
        }
    }
}

struct ConfettiParticle: Identifiable, Equatable {
    let id: UUID
    let seed: Int
    let color: Color
    let angle: Double
    let rotation: Double
    let fall: Double
    let drift: Double
    let delay: Double
    let duration: Double
    let shape: ConfettiShape
}

enum ConfettiShape: CaseIterable {
    case rectangle, capsule, circle, star
}

private struct ConfettiPieceView: View {
    let particle: ConfettiParticle
    let size: CGSize
    @State private var progress: CGFloat = 0

    var body: some View {
        let startX = CGFloat((particle.seed * 37) % Int(max(1, size.width)))
        shape
            .fill(particle.color)
            .frame(width: 8, height: 12)
            .rotationEffect(.degrees(particle.rotation + progress * 360))
            .position(
                x: startX + CGFloat(particle.drift) * progress,
                y: -20 + CGFloat(particle.fall) * progress
            )
            .opacity(Double(1 - progress * 0.6))
            .onAppear {
                withAnimation(.easeIn(duration: particle.duration).delay(particle.delay)) {
                    progress = 1
                }
            }
    }

    private var shape: AnyShape {
        switch particle.shape {
        case .rectangle: return AnyShape(Rectangle())
        case .capsule:   return AnyShape(Capsule())
        case .circle:    return AnyShape(Circle())
        case .star:      return AnyShape(StarShape(points: 5))
        }
    }
}

private struct StarShape: Shape {
    let points: Int
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.45
        var path = Path()
        for i in 0..<(points * 2) {
            let angle = (Double(i) * .pi / Double(points)) - .pi / 2
            let r = i.isMultiple(of: 2) ? outer : inner
            let p = CGPoint(
                x: center.x + CGFloat(cos(angle)) * r,
                y: center.y + CGFloat(sin(angle)) * r
            )
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        return path
    }
}

private struct AnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path
    init<S: Shape>(_ wrapped: S) {
        self._path = { rect in wrapped.path(in: rect) }
    }
    func path(in rect: CGRect) -> Path { _path(rect) }
}
