import SwiftUI

/// A floating-but-non-blocking "Stop speaking" button. Appears only while
/// the synthesizer is actively producing audio. Fixes the long-standing
/// complaint that Play-All had no cancel.
struct SpeechStopHUD: View {
    @ObservedObject private var speech = Speech.shared

    var body: some View {
        HStack(spacing: Spacing.xs) {
            WaveformPulse()
                .frame(width: 16, height: 16)
                .foregroundStyle(.white)
            if !speech.nowSpeaking.isEmpty {
                Text(speech.nowSpeaking)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .frame(maxWidth: 220)
            }
            if speech.queueRemaining > 0 {
                Text("+\(speech.queueRemaining) queued")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Button {
                Speech.shared.stop()
            } label: {
                Label("Stop", systemImage: "stop.fill")
                    .labelStyle(.titleAndIcon)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xxs)
                    .background(Color.red.opacity(0.85), in: Capsule())
            }
            .buttonStyle(.plain)
            .keyboardShortcut(".", modifiers: [.command])
            .help("Stop speaking (⌘.)")
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(Color.black.opacity(0.78), in: Capsule())
        .overlay(Capsule().stroke(Color.white.opacity(0.1)))
        .shadow(color: .black.opacity(0.3), radius: 12, y: 4)
        .opacity(speech.isSpeaking ? 1 : 0)
        .scaleEffect(speech.isSpeaking ? 1 : 0.85)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: speech.isSpeaking)
        .allowsHitTesting(speech.isSpeaking)
    }
}

private struct WaveformPulse: View {
    @State private var phase: CGFloat = 0
    var body: some View {
        TimelineView(.animation) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            HStack(spacing: 2) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule()
                        .frame(width: 2)
                        .frame(height: 4 + CGFloat(abs(sin(t * 3 + Double(i))) * 10))
                }
            }
        }
    }
}
