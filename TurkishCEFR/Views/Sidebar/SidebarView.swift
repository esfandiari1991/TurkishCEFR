import SwiftUI

/// Hierarchical sidebar used by the three-column NavigationSplitView. Groups
/// navigation into four top-level sections:
///   • Learn — CEFR levels A1..C2
///   • Toolkit — Dictionary, Conjugator, SRS, Daily, Phrasebook, Podcasts
///   • Progress — Stats, Heatmap, Badges
///   • Info / utility pills at the bottom (XP, streak, badge count)
///
/// Each sub-item is a `NavigationLink` with an `AppSection` value, so the
/// caller in `ContentView` can react with a single `.navigationDestination`
/// (or plain `onChange`) switch.
struct SidebarView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore

    @Binding var selection: AppSection?

    var body: some View {
        List(selection: $selection) {
            // Top padding breathes the window header so the first row no
            // longer kisses the traffic-light buttons.
            Color.clear.frame(height: Spacing.sm)
                .listRowSeparator(.hidden)

            Section {
                ForEach(CEFRLevel.allCases) { level in
                    NavigationLink(value: AppSection.level(level)) {
                        LevelRow(level: level,
                                 completion: progress.completion(for: curriculum.lessons(for: level)),
                                 lessonCount: curriculum.lessons(for: level).count)
                    }
                }
            } header: {
                sectionHeader("CEFR Levels", systemImage: "graduationcap.fill")
            }

            Section {
                ForEach(AppSection.Tool.classicTools) { tool in
                    NavigationLink(value: AppSection.tool(tool)) {
                        ToolRow(tool: tool)
                    }
                }
                NavigationLink(value: AppSection.podcasts) {
                    ToolRow(tool: nil,
                            title: "Podcastler · Free Podcasts",
                            systemImage: "headphones.circle.fill",
                            tint: .mint)
                }
            } header: {
                sectionHeader("Toolkit", systemImage: "hammer.fill")
            }

            Section {
                ForEach(AppSection.Tool.practiceTools) { tool in
                    NavigationLink(value: AppSection.tool(tool)) {
                        ToolRow(tool: tool)
                    }
                }
            } header: {
                sectionHeader("Practice & Reflect", systemImage: "sparkles")
            }

            Section {
                ForEach(AppSection.Tool.labTools) { tool in
                    NavigationLink(value: AppSection.tool(tool)) {
                        ToolRow(tool: tool)
                    }
                }
            } header: {
                sectionHeader("Lab", systemImage: "testtube.2")
            }

            Section {
                ForEach(AppSection.ProgressTab.allCases) { tab in
                    NavigationLink(value: AppSection.progress(tab)) {
                        ProgressRowView(tab: tab)
                    }
                }
            } header: {
                sectionHeader("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("TurkishCEFR")
        .navigationSplitViewColumnWidth(min: 232, ideal: 254, max: 290)
        .safeAreaInset(edge: .bottom) {
            SidebarFooter()
        }
    }

    private func sectionHeader(_ title: String, systemImage: String) -> some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: systemImage)
                .foregroundStyle(.tint)
            Text(title)
        }
        .font(.headline)
        .padding(.vertical, Spacing.xxs)
    }
}

private struct LevelRow: View {
    let level: CEFRLevel
    let completion: Double
    let lessonCount: Int

    var body: some View {
        HStack(spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(level.gradient)
                    .frame(width: IconSize.large, height: IconSize.large)
                Image(systemName: level.systemImage)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: Spacing.xs) {
                    Text(level.rawValue)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    Text(level.englishTitle)
                        .font(.system(size: 12))
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
        .padding(.vertical, Spacing.xxs)
        .contentShape(Rectangle())
    }
}

private struct ToolRow: View {
    // One of either a predefined `AppSection.Tool` or a custom entry.
    var tool: AppSection.Tool? = nil
    var title: String? = nil
    var systemImage: String? = nil
    var tint: Color? = nil

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: tool?.systemImage ?? systemImage ?? "questionmark.app")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: IconSize.large, height: IconSize.large)
                .background(Circle().fill(tool?.tint ?? tint ?? .accentColor))
            Text(tool?.title ?? title ?? "")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            Spacer()
        }
        .padding(.vertical, Spacing.xxs)
        .contentShape(Rectangle())
    }
}

private struct ProgressRowView: View {
    let tab: AppSection.ProgressTab
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: tab.systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: IconSize.large, height: IconSize.large)
                .background(Circle().fill(tab.tint))
            Text(tab.title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            Spacer()
        }
        .padding(.vertical, Spacing.xxs)
        .contentShape(Rectangle())
    }
}

private struct SidebarFooter: View {
    @EnvironmentObject private var progress: ProgressStore
    @ObservedObject private var network = NetworkModeStore.shared

    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                pill(icon: "bolt.fill", tint: .yellow,
                     value: "Lv \(progress.stats.level)")
                pill(icon: "flame.fill",
                     tint: progress.stats.streakDays > 0 ? .orange : .secondary,
                     value: "\(progress.stats.streakDays)d")
                pill(icon: "rosette", tint: .pink,
                     value: "\(progress.stats.unlockedBadges.count)")
                Spacer()
                Text("\(progress.stats.totalXP) XP")
                    .font(.caption.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: Spacing.xs) {
                Button {
                    network.toggle()
                } label: {
                    Label(network.mode.title, systemImage: network.mode.systemImage)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(network.mode.tint.opacity(0.9)))
                }
                .buttonStyle(.plain)
                .help(network.mode.description)
                Spacer()
                Text("v1.2").font(.caption2).foregroundStyle(.secondary)
            }
        }
        .padding(Spacing.sm)
        .background(.thinMaterial)
    }

    private func pill(icon: String, tint: Color, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).foregroundStyle(tint)
            Text(value)
                .font(.caption.monospacedDigit().weight(.semibold))
        }
    }
}
