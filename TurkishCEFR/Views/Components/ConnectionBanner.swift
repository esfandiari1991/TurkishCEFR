import SwiftUI

/// Phases a data source can be in during app start-up. Used by the
/// "Bağlanıyor → Bağlandı" banner.
enum ConnectionPhase {
    case idle
    case connecting(label: String)
    case ready(summary: String)
    case failed(message: String)
}

/// Observable façade that lets any view report progress as heavy data
/// stores finish loading in the background. The app displays a single
/// friendly "Connected — 20,412 sentences · 10,203 words · all offline"
/// banner at launch so the user sees the work happening and knows
/// when the corpus is ready.
@MainActor
final class ConnectionCenter: ObservableObject {
    static let shared = ConnectionCenter()

    @Published var phase: ConnectionPhase = .idle
    @Published var bannerVisible: Bool = false
    private var dismissTask: Task<Void, Never>? = nil

    func beginLoading(_ label: String) {
        dismissTask?.cancel()
        phase = .connecting(label: label)
        bannerVisible = true
    }

    func finishLoading(summary: String) {
        phase = .ready(summary: summary)
        bannerVisible = true
        dismissTask?.cancel()
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 3_200_000_000)
            await MainActor.run { self?.bannerVisible = false }
        }
    }

    func reportFailure(_ message: String) {
        phase = .failed(message: message)
        bannerVisible = true
    }
}

struct ConnectionBanner: View {
    @ObservedObject private var center = ConnectionCenter.shared

    var body: some View {
        Group {
            if center.bannerVisible {
                content
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: center.bannerVisible)
    }

    @ViewBuilder
    private var content: some View {
        switch center.phase {
        case .idle:
            EmptyView()
        case .connecting(let label):
            banner(icon: "antenna.radiowaves.left.and.right",
                   title: "Bağlanıyor · Connecting",
                   detail: label,
                   tint: .orange,
                   showProgress: true)
        case .ready(let summary):
            banner(icon: "checkmark.seal.fill",
                   title: "Bağlandı · Connected",
                   detail: summary,
                   tint: .green,
                   showProgress: false)
        case .failed(let message):
            banner(icon: "exclamationmark.triangle.fill",
                   title: "Couldn't connect",
                   detail: message,
                   tint: .red,
                   showProgress: false)
        }
    }

    private func banner(icon: String, title: String, detail: String,
                        tint: Color, showProgress: Bool) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 0) {
                Text(title).font(.callout.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
            if showProgress {
                ProgressView().controlSize(.small)
            }
            Button {
                ConnectionCenter.shared.bannerVisible = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().stroke(tint.opacity(0.25)))
        .shadow(color: .black.opacity(0.18), radius: 10, y: 4)
    }
}
