import SwiftUI

/// Curated free Turkish-learning podcasts, grouped by CEFR level, with a
/// "Listen" button that opens the show in the user's default browser /
/// podcast app.
struct PodcastsView: View {
    @Environment(\.openURL) private var openURL
    @State private var selectedLevel: CEFRLevel? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            header
            Divider()
            filterBar
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.lg, pinnedViews: [.sectionHeaders]) {
                    ForEach(PodcastsContent.byLevel, id: \.level) { entry in
                        if selectedLevel == nil || selectedLevel == entry.level {
                            Section {
                                ForEach(entry.shows) { show in
                                    PodcastCard(show: show) {
                                        openURL(show.url)
                                    }
                                }
                            } header: {
                                levelHeader(entry.level, count: entry.shows.count)
                            }
                        }
                    }
                }
                .padding(.bottom, Spacing.xxl)
            }
        }
        .padding(Spacing.lg)
        .frame(minWidth: 720, minHeight: 520)
    }

    private var header: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "headphones.circle.fill")
                .font(.system(size: IconSize.display))
                .foregroundStyle(LinearGradient(colors: [.orange, .pink],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing))
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Free Turkish Podcasts")
                    .displayTitle()
                Text("Curated by CEFR level — tap any show to listen in your browser or podcast app. All 20+ shows are freely streamable.")
                    .font(DisplayFont.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }

    private var filterBar: some View {
        HStack(spacing: Spacing.xs) {
            filterChip(title: "All", level: nil)
            ForEach(CEFRLevel.allCases) { level in
                filterChip(title: level.rawValue, level: level)
            }
            Spacer()
            Text("\(PodcastsContent.shows.count) shows · all free")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func filterChip(title: String, level: CEFRLevel?) -> some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                selectedLevel = level
            }
        } label: {
            Text(title)
                .font(.callout.weight(.semibold))
                .foregroundStyle(selectedLevel == level ? Color.white : Color.primary)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xxs)
                .background(
                    Capsule().fill(selectedLevel == level
                                   ? (level?.accentColor ?? Color.accentColor)
                                   : Color.secondary.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
    }

    private func levelHeader(_ level: CEFRLevel, count: Int) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: level.systemImage)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: IconSize.large, height: IconSize.large)
                .background(Circle().fill(level.gradient))
            VStack(alignment: .leading, spacing: 0) {
                Text("\(level.rawValue) · \(level.englishTitle)")
                    .sectionTitle()
                Text("\(count) podcast\(count == 1 ? "" : "s") curated for this level")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, Spacing.xs)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.85))
    }
}

private struct PodcastCard: View {
    let show: PodcastShow
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(alignment: .top, spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [.orange.opacity(0.85), .red.opacity(0.85)],
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing))
                    Image(systemName: show.systemImage)
                        .font(.system(size: IconSize.large, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 72, height: 72)

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(alignment: .firstTextBaseline, spacing: Spacing.xs) {
                        Text(show.title)
                            .font(DisplayFont.card)
                            .foregroundStyle(.primary)
                        ForEach(show.levels, id: \.self) { level in
                            Text(level)
                                .font(.caption2.weight(.bold))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.accentColor.opacity(0.15), in: Capsule())
                                .foregroundStyle(.primary)
                        }
                    }
                    Text("Host: \(show.host) · \(show.accent)")
                        .font(.caption).foregroundStyle(.secondary)
                    Text(show.summary)
                        .font(DisplayFont.body)
                        .foregroundStyle(.primary.opacity(0.85))
                        .lineSpacing(LineHeight.body)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: Spacing.sm) {
                        Label("Listen", systemImage: "play.circle.fill")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xxs)
                            .background(Capsule().fill(Color.accentColor))
                        if show.rss != nil {
                            Text("RSS available")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, Spacing.xs)
                                .padding(.vertical, 2)
                                .background(Capsule().stroke(Color.secondary.opacity(0.3)))
                        }
                    }
                }
                Spacer()
            }
            .padding(Spacing.md)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06)))
            .contentShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .help("Open \(show.title) — \(show.url.absoluteString)")
    }
}
