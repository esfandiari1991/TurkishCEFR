import SwiftUI

struct ExerciseHostView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    let lesson: Lesson
    let exercise: Exercise

    @State private var awardedAmount: Int?

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(GradientBackground(level: lesson.level))
        .overlay(alignment: .top) {
            if let amount = awardedAmount {
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                    Text("+\(amount) XP").font(.caption.weight(.bold).monospacedDigit())
                }
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(LinearGradient(colors: [.orange, .yellow],
                                           startPoint: .leading, endPoint: .trailing),
                            in: Capsule())
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
                .padding(.top, 50)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: exercise.systemImage)
                .foregroundStyle(lesson.level.accentColor)
            Text(exercise.title).font(.headline)
            Spacer()
            Button("Close") { dismiss() }
                .keyboardShortcut(.cancelAction)
        }
        .padding(14)
    }

    @ViewBuilder
    private var content: some View {
        switch exercise {
        case .flashcard(let cards):
            FlashcardView(flashcards: cards,
                          tint: lesson.level.accentColor) {
                award(xp: XPAward.flashcardCompleted, perfect: false)
            }
        case .multipleChoice(let q):
            MultipleChoiceView(question: q,
                               tint: lesson.level.accentColor) { correctOnFirstTry in
                award(xp: correctOnFirstTry ? XPAward.multipleChoicePerfect
                                            : XPAward.multipleChoicePerfect / 2,
                      perfect: correctOnFirstTry)
            }
        case .fillInBlank(let q):
            FillInBlankView(question: q,
                            tint: lesson.level.accentColor) { correctOnFirstTry in
                award(xp: correctOnFirstTry ? XPAward.fillInBlankPerfect
                                            : XPAward.fillInBlankPerfect / 2,
                      perfect: correctOnFirstTry)
            }
        }
    }

    private func award(xp: Int, perfect: Bool) {
        let amount = progress.markExerciseCompleted(
            lessonID: lesson.id,
            exerciseID: exercise.id,
            xp: xp,
            perfect: perfect
        )
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            awardedAmount = amount
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation { awardedAmount = nil }
        }
    }
}
