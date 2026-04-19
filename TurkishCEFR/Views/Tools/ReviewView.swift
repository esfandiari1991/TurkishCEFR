import SwiftUI

/// Spaced-repetition review deck. Presents one due card at a time, lets the
/// learner grade how well they remembered it, then schedules the next review.
struct ReviewView: View {
    @StateObject private var srs = SRSStore.shared
    @EnvironmentObject private var progress: ProgressStore

    @State private var flipped: Bool = false
    @State private var currentID: String? = nil

    private var current: SRSStore.Card? {
        if let id = currentID, let c = srs.cards.first(where: { $0.id == id }) {
            return c
        }
        return srs.dueCards.first
    }

    var body: some View {
        VStack(spacing: 18) {
            header
            if let c = current {
                cardView(c)
                graders(c)
            } else {
                emptyState
            }
        }
        .padding(28)
        .frame(minWidth: 520, minHeight: 480)
        .background(.regularMaterial)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "brain.head.profile")
                .foregroundStyle(BrandTheme.turquoise)
            Text("Spaced Repetition Review")
                .font(.title3.weight(.semibold))
            Spacer()
            SoftPill(text: "\(srs.dueCount) due", tint: BrandTheme.gold)
            SoftPill(text: "\(srs.cards.count) total", tint: BrandTheme.turquoise)
        }
    }

    private func cardView(_ c: SRSStore.Card) -> some View {
        GlassCard(tint: BrandTheme.turquoise, cornerRadius: 22, padding: 28, intensity: 0.1) {
            VStack(spacing: 18) {
                if flipped {
                    Text(c.back)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale))
                    Text(c.front)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                } else {
                    Text(c.front)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale))
                    Button {
                        Speech.shared.speak(c.front)
                    } label: {
                        Label("Play", systemImage: "speaker.wave.2.fill")
                            .labelStyle(.iconOnly)
                            .font(.title2)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 180)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.28)) { flipped.toggle() }
        }
    }

    private func graders(_ c: SRSStore.Card) -> some View {
        VStack(spacing: 12) {
            if !flipped {
                Text("Tap the card to reveal the answer")
                    .font(.callout).foregroundStyle(.secondary)
            } else {
                HStack(spacing: 12) {
                    gradeButton(c, grade: .again, title: "Again",
                                tint: .red, shortcut: "1")
                    gradeButton(c, grade: .hard, title: "Hard",
                                tint: BrandTheme.crimson, shortcut: "2")
                    gradeButton(c, grade: .good, title: "Good",
                                tint: BrandTheme.turquoise, shortcut: "3")
                    gradeButton(c, grade: .easy, title: "Easy",
                                tint: .green, shortcut: "4")
                }
            }
        }
    }

    private func gradeButton(_ c: SRSStore.Card, grade: SRSStore.Grade,
                             title: String, tint: Color, shortcut: Character) -> some View {
        Button {
            srs.grade(c.id, grade)
            progress.awardXP(grade == .easy ? 6 : 3,
                              reason: "SRS review · \(title)")
            withAnimation(.easeOut(duration: 0.18)) {
                flipped = false
                currentID = srs.dueCards.first?.id
            }
        } label: {
            VStack(spacing: 2) {
                Text(title).font(.body.weight(.semibold))
                Text("⌨ \(String(shortcut))").font(.caption).opacity(0.65)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .keyboardShortcut(KeyEquivalent(shortcut), modifiers: [])
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green.gradient)
            Text("All caught up! 🎉")
                .font(.title3.weight(.semibold))
            Text("Finish lessons to harvest new flashcards into your review deck. Cards become due based on how well you remembered them last time.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 360)
        }
    }
}
