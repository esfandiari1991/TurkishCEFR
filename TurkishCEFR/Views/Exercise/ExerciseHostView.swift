import SwiftUI

struct ExerciseHostView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    let lesson: Lesson
    let exercise: Exercise

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(GradientBackground(level: lesson.level))
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
                progress.markExerciseCompleted(lessonID: lesson.id, exerciseID: exercise.id)
            }
        case .multipleChoice(let q):
            MultipleChoiceView(question: q,
                               tint: lesson.level.accentColor) {
                progress.markExerciseCompleted(lessonID: lesson.id, exerciseID: exercise.id)
            }
        case .fillInBlank(let q):
            FillInBlankView(question: q,
                            tint: lesson.level.accentColor) {
                progress.markExerciseCompleted(lessonID: lesson.id, exerciseID: exercise.id)
            }
        }
    }
}
