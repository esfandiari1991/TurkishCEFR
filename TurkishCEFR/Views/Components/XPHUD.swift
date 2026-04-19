import SwiftUI

/// Compact gamification HUD — level, XP progress bar, streak, open badges shelf.
struct XPHUD: View {
    @EnvironmentObject private var progress: ProgressStore
    @Binding var showBadgesSheet: Bool

    var body: some View {
        HStack(spacing: 14) {
            levelBadge
            xpBar
            streakChip
            badgesButton
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.thinMaterial, in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.06)))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
    }

    private var levelBadge: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [.orange, .pink],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 30, height: 30)
            Text("\(progress.stats.level)")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .help("Level \(progress.stats.level)")
    }

    private var xpBar: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Text("\(progress.stats.totalXP) XP")
                    .font(.caption.monospacedDigit().weight(.semibold))
                Text("· \(progress.stats.xpAtNextLevel - progress.stats.totalXP) to next")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.secondary.opacity(0.25))
                    Capsule().fill(LinearGradient(colors: [.orange, .yellow],
                                                  startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(3, geo.size.width * progress.stats.progressInLevel))
                        .animation(.spring(response: 0.3, dampingFraction: 0.85),
                                   value: progress.stats.progressInLevel)
                }
            }
            .frame(width: 160, height: 6)
        }
    }

    private var streakChip: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .foregroundStyle(progress.stats.streakDays > 0 ? .orange : .secondary)
            Text("\(progress.stats.streakDays)d")
                .font(.caption.monospacedDigit().weight(.semibold))
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Color.orange.opacity(progress.stats.streakDays > 0 ? 0.15 : 0.05), in: Capsule())
        .help(progress.stats.streakDays > 0
              ? "\(progress.stats.streakDays)-day streak · longest \(progress.stats.longestStreak)"
              : "Study today to start a streak")
    }

    private var badgesButton: some View {
        Button {
            showBadgesSheet = true
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "rosette")
                Text("\(progress.stats.unlockedBadges.count)/\(BadgeCatalog.all.count)")
                    .font(.caption.monospacedDigit().weight(.semibold))
            }
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color.yellow.opacity(0.15), in: Capsule())
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .help("Show earned badges")
    }
}

/// Overlay shown when the player levels up.
struct LevelUpToast: View {
    let event: ProgressStore.LevelUpEvent
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.orange, .pink],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 44, height: 44)
                Text("\(event.newLevel)")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading) {
                Text("Seviye \(event.newLevel)!")
                    .font(.headline)
                Text("Level up — keep going!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.1)))
        .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
    }
}

/// Transient "+XX XP" floater shown when an exercise completes.
struct XPChip: View {
    let event: ProgressStore.XPAwardEvent
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.fill")
            Text("+\(event.amount) XP")
                .font(.caption.weight(.bold).monospacedDigit())
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(LinearGradient(colors: [.orange, .yellow],
                                   startPoint: .leading, endPoint: .trailing),
                    in: Capsule())
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
    }
}

/// Toast shown when a new badge is unlocked.
struct BadgeToast: View {
    let badge: Badge
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(badge.tint.color.gradient).frame(width: 44, height: 44)
                Image(systemName: badge.systemImage)
                    .foregroundStyle(.white)
                    .font(.title3)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("New badge")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    if badge.xpReward > 0 {
                        Text("· +\(badge.xpReward) XP")
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(.orange)
                    }
                }
                Text(badge.title).font(.headline)
                Text(badge.subtitle).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.1)))
        .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
    }
}
