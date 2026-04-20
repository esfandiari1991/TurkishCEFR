import SwiftUI

/// Compact gamification HUD — level, XP progress bar, streak, badges button.
///
/// The previous version was a fat pill pinned to the top of the window that
/// overlapped content and couldn't be moved. This version:
///   • Collapses to a small "Lv 4 · ⚡" chip by default.
///   • Expands to the full stat bar on click / hover.
///   • Remembers whether the user dismissed it across launches.
///   • Is *draggable* — hold ⌥ (Option) and drag anywhere; its position is
///     persisted in `AppStorage` so the next launch restores it.
///   • Every sub-element deep-links into the right tab (XP → Stats, 🔥 → Streak,
///     🏆 → Badges).
struct XPHUD: View {
    @EnvironmentObject private var progress: ProgressStore

    @Binding var showBadgesSheet: Bool
    var openStats: () -> Void = {}
    var openStreak: () -> Void = {}

    @AppStorage("hud.expanded")    private var expanded: Bool = true
    @AppStorage("hud.visible")     private var visible: Bool = true
    @AppStorage("hud.offsetX")     private var offsetX: Double = 0
    @AppStorage("hud.offsetY")     private var offsetY: Double = 0

    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging: Bool = false

    var body: some View {
        Group {
            if visible {
                content
                    .offset(x: offsetX + dragOffset.width,
                            y: offsetY + dragOffset.height)
                    .gesture(dragGesture)
                    .animation(.spring(response: 0.25, dampingFraction: 0.9), value: expanded)
            } else {
                reopenPill
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if expanded {
            expandedHUD
        } else {
            collapsedChip
        }
    }

    // MARK: - Expanded

    private var expandedHUD: some View {
        HStack(spacing: Spacing.sm) {
            Button { openStats() } label: { levelBadge }
                .buttonStyle(.plain)
                .help("Open Stats Dashboard")

            Button { openStats() } label: { xpBar }
                .buttonStyle(.plain)
                .help("Your XP progress toward the next level · click for Stats")

            Button { openStreak() } label: { streakChip }
                .buttonStyle(.plain)
                .help("Current study streak · click for Stats")

            Button { showBadgesSheet = true } label: { badgesButton }
                .buttonStyle(.plain)
                .help("Show earned badges")

            Button { expanded = false } label: {
                Image(systemName: "chevron.compact.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Collapse the HUD")

            Button { visible = false } label: {
                Image(systemName: "xmark")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Hide the HUD (re-enable from the sidebar)")
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(.thinMaterial, in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.06)))
        .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
        .overlay(alignment: .topLeading) {
            dragHint
        }
        .contextMenu { hudContextMenu }
    }

    private var collapsedChip: some View {
        Button {
            expanded = true
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill").foregroundStyle(.yellow)
                Text("Lv \(progress.stats.level)")
                    .font(.caption.monospacedDigit().weight(.semibold))
                if progress.stats.streakDays > 0 {
                    Image(systemName: "flame.fill").foregroundStyle(.orange)
                    Text("\(progress.stats.streakDays)")
                        .font(.caption.monospacedDigit())
                }
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs)
        }
        .buttonStyle(.plain)
        .background(.thinMaterial, in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.06)))
        .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
        .contextMenu { hudContextMenu }
        .help("Expand player HUD · right-click for options")
    }

    private var reopenPill: some View {
        Button {
            visible = true
            expanded = false
        } label: {
            Image(systemName: "bolt.fill")
                .font(.caption)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(.thinMaterial, in: Capsule())
        }
        .buttonStyle(.plain)
        .help("Show player HUD")
    }

    private var dragHint: some View {
        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
            .font(.system(size: 8))
            .foregroundStyle(.secondary.opacity(isDragging ? 1 : 0.25))
            .padding(4)
            .offset(x: -12, y: 2)
            .help("Hold ⌥ and drag to reposition the HUD")
    }

    @ViewBuilder
    private var hudContextMenu: some View {
        Button(expanded ? "Collapse" : "Expand") { expanded.toggle() }
        Button("Reset position") { offsetX = 0; offsetY = 0 }
        Divider()
        Button("Hide HUD") { visible = false }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { v in
                // Only drag when Option key is held, so normal clicks still work.
                if NSEvent.modifierFlags.contains(.option) {
                    dragOffset = v.translation
                }
            }
            .onEnded { v in
                if NSEvent.modifierFlags.contains(.option) {
                    offsetX += Double(v.translation.width)
                    offsetY += Double(v.translation.height)
                }
                dragOffset = .zero
            }
    }

    // MARK: - Sub-views

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
                    Capsule()
                        .fill(LinearGradient(colors: [.orange, .yellow],
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
    }

    private var badgesButton: some View {
        HStack(spacing: 6) {
            Image(systemName: "rosette")
            Text("\(progress.stats.unlockedBadges.count)/\(BadgeCatalog.all.count)")
                .font(.caption.monospacedDigit().weight(.semibold))
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Color.yellow.opacity(0.15), in: Capsule())
        .foregroundStyle(.primary)
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
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(.thinMaterial, in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.08)))
    }
}

/// Transient "badge unlocked" toast.
struct BadgeToast: View {
    let badge: Badge
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: badge.systemImage)
                .font(.title3)
                .foregroundStyle(.yellow)
            VStack(alignment: .leading, spacing: 2) {
                Text(badge.title).font(.headline)
                Text(badge.subtitle).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.08)))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }
}
