import SwiftUI

struct FlashcardView: View {
    let flashcards: FlashcardSet
    let tint: Color
    let onComplete: () -> Void

    @State private var index: Int = 0
    @State private var flipped: Bool = false
    @State private var seen: Set<Int> = []

    private var card: VocabularyItem { flashcards.cards[index] }
    private var progress: Double {
        flashcards.cards.isEmpty ? 0 : Double(seen.count) / Double(flashcards.cards.count)
    }

    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: progress)
                .tint(tint)
                .padding(.horizontal, 40)

            Spacer()

            ZStack {
                CardFace(text: card.turkish,
                         subtitle: card.partOfSpeech.label,
                         tint: tint, isFront: true)
                    .opacity(flipped ? 0 : 1)
                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                CardFace(text: card.english,
                         subtitle: card.exampleTR ?? "",
                         tint: tint, isFront: false)
                    .opacity(flipped ? 1 : 0)
                    .rotation3DEffect(.degrees(flipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
            }
            .frame(height: 220)
            .padding(.horizontal, 40)
            .onTapGesture {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    flipped.toggle()
                }
            }

            HStack(spacing: 10) {
                PronunciationButton(text: card.turkish, tint: tint, showLabel: true)
                Text("Tap the card to flip")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 16) {
                Button {
                    advance(direction: -1)
                } label: {
                    Label("Previous", systemImage: "chevron.backward")
                        .frame(minWidth: 110)
                }
                .disabled(index == 0)

                Button {
                    advance(direction: 1)
                } label: {
                    Label(isLast ? "Finish" : "Next", systemImage: isLast ? "checkmark" : "chevron.forward")
                        .frame(minWidth: 110)
                }
                .buttonStyle(.borderedProminent)
                .tint(tint)
            }
            .padding(.bottom, 30)
        }
        .onAppear { seen.insert(index) }
    }

    private var isLast: Bool { index == flashcards.cards.count - 1 }

    private func advance(direction: Int) {
        withAnimation(.easeInOut(duration: 0.25)) { flipped = false }
        let newIndex = index + direction
        if newIndex < 0 { return }
        if newIndex >= flashcards.cards.count {
            onComplete()
            return
        }
        index = newIndex
        seen.insert(index)
    }
}

private struct CardFace: View {
    let text: String
    let subtitle: String
    let tint: Color
    let isFront: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(isFront ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(tint.opacity(0.15)))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(tint.opacity(0.25), lineWidth: 1)
            )
            .overlay(
                VStack(spacing: 10) {
                    Text(text)
                        .font(.system(size: 44, weight: .semibold, design: .serif))
                        .multilineTextAlignment(.center)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            )
            .shadow(color: tint.opacity(0.2), radius: 16, y: 6)
    }
}
