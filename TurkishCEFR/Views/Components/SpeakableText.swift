import SwiftUI

/// A Turkish-aware text view. Every Turkish string in the app should use this
/// view rather than plain `Text` so the user can tap (or press the mini
/// speaker icon) to hear it spoken with the Istanbul-accent voice. The
/// underline-on-hover signals the interactivity.
struct SpeakableText: View {
    let text: String
    var font: Font = DisplayFont.body
    var weight: Font.Weight? = nil
    var color: Color = .primary
    var alignment: TextAlignment = .leading
    var showSpeaker: Bool = true

    @State private var hovering: Bool = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xs) {
            Text(text)
                .font(weight == nil ? font : font.weight(weight!))
                .foregroundStyle(color)
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
                .underline(hovering, pattern: .dot, color: .secondary.opacity(0.6))
                .contentShape(Rectangle())
                .onTapGesture {
                    Speech.shared.speak(text)
                }
                .onHover { hovering = $0 }
                .help("Tap to hear: \(text)")
            if showSpeaker {
                Button {
                    Speech.shared.speak(text)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.caption2)
                        .foregroundStyle(.secondary.opacity(0.6))
                        .opacity(hovering ? 1 : 0.5)
                }
                .buttonStyle(.plain)
                .help("Hear: \(text)")
            }
        }
    }
}

/// A convenience factory for very large Turkish display titles.
struct SpeakableTitle: View {
    let text: String
    var color: Color = .primary
    var body: some View {
        SpeakableText(text: text,
                      font: DisplayFont.turkishTitle,
                      color: color,
                      showSpeaker: true)
    }
}
