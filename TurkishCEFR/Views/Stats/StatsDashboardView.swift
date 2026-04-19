import SwiftUI

/// The sophisticated stats dashboard — shows XP, level progress, heatmap,
/// completion bars, badge progress, and accuracy at a glance.
struct StatsDashboardView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                levelCard
                keyStats
                heatmapCard
                levelBars
                badgeShowcase
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 760, minHeight: 640)
        .background(BrandTheme.darkAppBackground)
        .overlay(alignment: .topTrailing) {
            Button("Close") { dismiss() }
                .keyboardShortcut(.cancelAction)
                .padding(16)
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(BrandTheme.primaryGradient)
                    .frame(width: 56, height: 56)
                Image(systemName: "chart.bar.xaxis.ascending")
                    .foregroundStyle(.white)
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("İstatistikler · Your learning at a glance")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("Every step you take compounds.")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private var levelCard: some View {
        GlassCard(tint: BrandTheme.crimson, cornerRadius: 22, padding: 22, intensity: 0.10) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .stroke(BrandTheme.crimson.opacity(0.2), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: progress.stats.progressInLevel)
                        .stroke(BrandTheme.primaryGradient,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 0) {
                        Text("Lv")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text("\(progress.stats.level)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .monospacedDigit()
                    }
                }
                .frame(width: 96, height: 96)

                VStack(alignment: .leading, spacing: 6) {
                    Text("\(progress.stats.totalXP) XP")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(BrandTheme.primaryGradient)
                    Text("\(max(0, progress.stats.xpAtNextLevel - progress.stats.totalXP)) XP to level \(progress.stats.level + 1)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    GradientProgressBar(progress: progress.stats.progressInLevel,
                                        gradient: BrandTheme.primaryGradient)
                        .frame(height: 10)
                }
                Spacer()
            }
        }
    }

    private var keyStats: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 170), spacing: 12)], spacing: 12) {
            BigStatTile(title: "Current streak",
                        value: "\(progress.stats.streakDays)d",
                        caption: "Longest \(progress.stats.longestStreak)d",
                        systemImage: "flame.fill",
                        tint: .orange)
            BigStatTile(title: "Words mastered",
                        value: "\(progress.masteredWordCount())",
                        caption: "across all lessons",
                        systemImage: "character.book.closed.fill",
                        tint: BrandTheme.turquoise)
            BigStatTile(title: "Lessons complete",
                        value: "\(progress.stats.lessonsCompleted)",
                        caption: "of \(curriculum.allLessons.count)",
                        systemImage: "book.closed.fill",
                        tint: BrandTheme.gold)
            BigStatTile(title: "Accuracy",
                        value: "\(progress.stats.accuracyPercent)%",
                        caption: "\(progress.stats.exercisePerfectCount) / \(progress.stats.exerciseAttempts)",
                        systemImage: "target",
                        tint: .green)
            BigStatTile(title: "Study time",
                        value: progress.stats.humanStudyTime,
                        caption: "\(progress.stats.studyDayCount) active days",
                        systemImage: "clock.fill",
                        tint: .indigo)
            BigStatTile(title: "Badges",
                        value: "\(progress.stats.unlockedBadges.count)",
                        caption: "of \(BadgeCatalog.all.count)",
                        systemImage: "rosette",
                        tint: .pink)
        }
    }

    private var heatmapCard: some View {
        SectionCard(title: "Daily heatmap · Günlük ısı haritası",
                    systemImage: "square.grid.4x3.fill",
                    tint: BrandTheme.turquoise,
                    subtitle: "Last 18 weeks of study activity") {
            HeatmapView(weeks: 18,
                        dailyActivity: progress.stats.dailyActivity,
                        tint: BrandTheme.turquoise)
        }
    }

    private var levelBars: some View {
        SectionCard(title: "Level completion · Seviyeler",
                    systemImage: "chart.bar.doc.horizontal",
                    tint: BrandTheme.gold) {
            VStack(spacing: 10) {
                ForEach(CEFRLevel.allCases) { level in
                    let lessons = curriculum.lessons(for: level)
                    LevelCompletionRow(
                        level: level,
                        completion: progress.completion(for: lessons),
                        lessonsDone: progress.lessonsCompleted(in: lessons),
                        lessonsTotal: lessons.count
                    )
                }
            }
        }
    }

    private var badgeShowcase: some View {
        SectionCard(title: "Recent badges · Rozetler",
                    systemImage: "rosette",
                    tint: .pink) {
            if progress.stats.unlockedBadges.isEmpty {
                Text("No badges earned yet — complete a lesson to unlock your first.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                let earned = BadgeCatalog.all.filter { progress.stats.unlockedBadges.contains($0.id) }
                    .prefix(8)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 10)], spacing: 10) {
                    ForEach(Array(earned)) { badge in
                        BadgeChip(badge: badge)
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

struct BigStatTile: View {
    let title: String
    let value: String
    let caption: String
    let systemImage: String
    let tint: Color

    var body: some View {
        GlassCard(tint: tint, cornerRadius: 18, padding: 16, intensity: 0.10) {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(tint)
                Text(value)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text(title)
                    .font(.caption.weight(.semibold))
                Text(caption)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct GradientProgressBar: View {
    let progress: Double
    let gradient: LinearGradient
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.secondary.opacity(0.18))
                Capsule()
                    .fill(gradient)
                    .frame(width: max(8, CGFloat(progress) * geo.size.width))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
            }
        }
    }
}

private struct LevelCompletionRow: View {
    let level: CEFRLevel
    let completion: Double
    let lessonsDone: Int
    let lessonsTotal: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(level.gradient)
                    .frame(width: 32, height: 32)
                Image(systemName: level.systemImage)
                    .foregroundStyle(.white)
                    .font(.caption.weight(.bold))
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(level.rawValue).font(.caption.weight(.bold))
                    Text(level.englishTitle).font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("\(lessonsDone)/\(lessonsTotal) · \(Int(completion * 100))%")
                        .font(.caption.monospacedDigit().weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                GradientProgressBar(
                    progress: completion,
                    gradient: LinearGradient(colors: [level.accentColor,
                                                      level.accentColor.opacity(0.6)],
                                              startPoint: .leading, endPoint: .trailing)
                )
                .frame(height: 8)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct BadgeChip: View {
    let badge: Badge
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle().fill(badge.tint.color.opacity(0.22))
                    .frame(width: 32, height: 32)
                Image(systemName: badge.systemImage)
                    .foregroundStyle(badge.tint.color)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(badge.title).font(.caption.weight(.semibold)).lineLimit(1)
                Text(badge.subtitle).font(.caption2).foregroundStyle(.secondary).lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}
