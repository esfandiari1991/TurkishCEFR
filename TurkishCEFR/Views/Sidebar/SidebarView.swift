import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore

    @Binding var selection: CEFRLevel?

    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(CEFRLevel.allCases) { level in
                    LevelRow(
                        level: level,
                        completion: progress.completion(for: curriculum.lessons(for: level)),
                        lessonCount: curriculum.lessons(for: level).count
                    )
                    .tag(level)
                }
            } header: {
                HStack(spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                    Text("CEFR Levels")
                }
                .font(.headline)
                .padding(.vertical, 4)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("TurkishCEFR")
        .safeAreaInset(edge: .bottom) {
            SidebarFooter()
        }
    }
}

private struct LevelRow: View {
    let level: CEFRLevel
    let completion: Double
    let lessonCount: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(level.gradient)
                    .frame(width: 34, height: 34)
                Image(systemName: level.systemImage)
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(level.rawValue)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    Text(level.englishTitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                ProgressView(value: completion)
                    .progressViewStyle(.linear)
                    .tint(level.accentColor)
            }
            Spacer(minLength: 0)
            Text("\(lessonCount)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

private struct SidebarFooter: View {
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 10) {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill").foregroundStyle(.yellow)
                    Text("Lv \(progress.stats.level)")
                        .font(.caption.monospacedDigit().weight(.semibold))
                }
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(progress.stats.streakDays > 0 ? .orange : .secondary)
                    Text("\(progress.stats.streakDays)d")
                        .font(.caption.monospacedDigit())
                }
                HStack(spacing: 4) {
                    Image(systemName: "rosette").foregroundStyle(.pink)
                    Text("\(progress.stats.unlockedBadges.count)")
                        .font(.caption.monospacedDigit())
                }
                Spacer()
                Text("\(progress.stats.totalXP) XP")
                    .font(.caption.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                Image(systemName: "star.circle.fill").foregroundStyle(.tint)
                Text("TurkishCEFR").font(.caption.weight(.semibold))
                Spacer()
                Text("v1.1").font(.caption2).foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(.thinMaterial)
    }
}
