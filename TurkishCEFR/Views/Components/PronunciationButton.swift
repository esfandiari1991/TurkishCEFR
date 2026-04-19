import SwiftUI

struct PronunciationButton: View {
    let text: String
    var tint: Color = .accentColor
    var showLabel: Bool = false

    var body: some View {
        Button {
            Speech.shared.speak(text)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "speaker.wave.2.fill")
                if showLabel { Text("Listen") }
            }
            .padding(.horizontal, showLabel ? 12 : 8)
            .padding(.vertical, 6)
            .background(tint.opacity(0.15), in: Capsule())
            .foregroundStyle(tint)
            .font(.caption.weight(.semibold))
        }
        .buttonStyle(.plain)
        .help("Hear: \(text)")
    }
}
