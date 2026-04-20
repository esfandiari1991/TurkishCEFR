import SwiftUI
import AppKit

/// Renders the two curated YouTube videos shipped with each lesson,
/// pulling the live list from `LinkHealthChecker.preferredVideos(for:)`.
/// Each card shows the thumbnail, title, channel, duration, and — if the
/// checker had to swap a dead primary for an alternate — a tiny "link
/// refreshed" chip so the user knows we quietly fixed something for them.
///
/// Clicking a card opens the video in the default browser. We never embed
/// YouTube — that would load their tracking JS inside the app, which we
/// don't want.
struct WatchAndLearnSection: View {
    let lesson: Lesson

    @ObservedObject private var checker = LinkHealthChecker.shared
    @ObservedObject private var networkMode = NetworkModeStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Label("Watch & Learn", systemImage: "play.rectangle.fill")
                    .font(.headline)
                    .foregroundStyle(BrandTheme.crimson)
                HelpBubble(
                    "Two short videos hand-picked to match this lesson. Click a thumbnail to open it in your browser. If a video ever disappears, we automatically switch to a backup.",
                    title: "Watch & Learn"
                )
                Spacer()
                if result.swapped {
                    SoftPill(text: "Link refreshed", tint: .orange)
                }
            }
            Text("Real Turkish speakers explaining this exact topic. ~5 minutes each.")
                .font(DisplayFont.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .top, spacing: Spacing.md) {
                ForEach(result.videos, id: \.youtubeID) { ref in
                    VideoCard(ref: ref, healthy: checker.isHealthy(ref))
                }
            }
            .task(id: networkMode.mode) {
                await checker.refresh(allowNetwork: networkMode.mode == .online)
            }
        }
    }

    private var result: (videos: [LessonResources.VideoRef], swapped: Bool) {
        checker.preferredVideos(for: lesson)
    }
}

private struct VideoCard: View {
    let ref: LessonResources.VideoRef
    let healthy: Bool

    @State private var hover = false
    @State private var thumb: NSImage?

    var body: some View {
        Button {
            NSWorkspace.shared.open(ref.watchURL)
        } label: {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                thumbnail
                VStack(alignment: .leading, spacing: 2) {
                    Text(ref.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 6) {
                        Text(ref.channel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text(ref.formattedDuration)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, Spacing.xs)
                .padding(.bottom, Spacing.xs)
            }
            .frame(width: 280)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.regularMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(hover ? BrandTheme.crimson.opacity(0.7)
                                  : Color.secondary.opacity(0.2),
                            lineWidth: hover ? 2 : 1)
            )
            .shadow(color: .black.opacity(hover ? 0.25 : 0.1),
                    radius: hover ? 12 : 4, y: hover ? 6 : 2)
            .opacity(healthy ? 1 : 0.55)
        }
        .buttonStyle(.plain)
        .onHover { hover = $0 }
        .help(healthy
              ? "Open in browser: \(ref.watchURL.absoluteString)"
              : "This video failed its last health-check. Open the backup instead.")
        .animation(.easeInOut(duration: 0.15), value: hover)
    }

    private var thumbnail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(LinearGradient(colors: [.black.opacity(0.25), .black.opacity(0.5)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(height: 158)
            if let thumb {
                Image(nsImage: thumb)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 158)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }

            // Play button overlay
            Circle()
                .fill(.black.opacity(0.55))
                .frame(width: 52, height: 52)
            Image(systemName: "play.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
        }
        .task(id: ref.youtubeID) {
            await loadThumb()
        }
    }

    private func loadThumb() async {
        guard thumb == nil else { return }
        guard NetworkModeStore.shared.mode == .online else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: ref.thumbnailURL)
            if let image = NSImage(data: data) {
                await MainActor.run { self.thumb = image }
            }
        } catch {
            // Silent — thumbnail is purely decorative; the play button
            // remains visible either way.
        }
    }
}
