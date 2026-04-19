import SwiftUI

struct BadgeWall: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 200, maximum: 260), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(BadgeCatalog.all) { badge in
                        BadgeTile(badge: badge,
                                  unlocked: progress.stats.unlockedBadges.contains(badge.id))
                    }
                }
                .padding(20)
            }
            .navigationTitle("Nişanlar · Badges")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .frame(minWidth: 720, minHeight: 520)
    }
}

struct BadgeTile: View {
    let badge: Badge
    let unlocked: Bool

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(unlocked ? AnyShapeStyle(badge.tint.color.gradient)
                                   : AnyShapeStyle(.secondary.opacity(0.2)))
                    .frame(width: 68, height: 68)
                Image(systemName: badge.systemImage)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(unlocked ? .white : .secondary)
                if !unlocked {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Circle().fill(.black.opacity(0.6)))
                        .offset(x: 22, y: 22)
                }
            }
            VStack(spacing: 2) {
                Text(badge.title).font(.headline)
                Text(badge.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                if badge.xpReward > 0 {
                    Text("+\(badge.xpReward) XP").font(.caption2.monospacedDigit())
                        .foregroundStyle(.orange)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.08)))
        .opacity(unlocked ? 1 : 0.7)
    }
}
