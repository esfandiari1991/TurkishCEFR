import SwiftUI

struct LessonDetailView: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson

    @State private var selectedExercise: Exercise?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                progressSection

                if !lesson.vocabulary.isEmpty {
                    VocabularySection(lesson: lesson)
                }
                if !lesson.grammar.isEmpty {
                    GrammarSection(lesson: lesson, grammar: lesson.grammar, tint: lesson.level.accentColor)
                }
                if !lesson.phrases.isEmpty {
                    PhrasesSection(lesson: lesson, phrases: lesson.phrases, tint: lesson.level.accentColor)
                }
                if !lesson.exercises.isEmpty {
                    ExerciseSection(lesson: lesson, onOpen: { selectedExercise = $0 })
                }

                WatchAndLearnSection(lesson: lesson)

                completeButton
            }
            .padding(32)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(GradientBackground(level: lesson.level))
        .navigationTitle(lesson.titleTR)
        .navigationSubtitle(lesson.titleEN)
        .sheet(item: $selectedExercise) { ex in
            ExerciseHostView(lesson: lesson, exercise: ex)
                .frame(minWidth: 560, minHeight: 480)
        }
        .onChange(of: progress.lessonProgress[lesson.id]) { _, _ in
            progress.maybeMarkLessonCompleted(lesson)
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(lesson.level.gradient)
                    .frame(width: 80, height: 80)
                    .shadow(color: lesson.level.accentColor.opacity(0.3), radius: 12, y: 6)
                Image(systemName: lesson.systemImage)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Text(lesson.level.rawValue)
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(lesson.level.accentColor.opacity(0.2),
                                    in: Capsule())
                    Text("Ders \(lesson.number)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(lesson.titleTR)
                    .font(.system(size: 30, weight: .bold, design: .serif))
                Text(lesson.titleEN)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(lesson.summary)
                    .font(.body)
                    .foregroundStyle(.primary.opacity(0.85))
            }
            Spacer()
        }
    }

    private var progressSection: some View {
        SectionCard(title: "Progress · İlerleme",
                    systemImage: "chart.bar.xaxis",
                    tint: lesson.level.accentColor) {
            CategoryProgressGrid(lesson: lesson, tint: lesson.level.accentColor)
        }
    }

    private var completeButton: some View {
        HStack {
            Spacer()
            Button {
                progress.markCompleted(lesson.id)
            } label: {
                Label(progress[lesson.id].completed ? "Completed" : "Mark Lesson Complete",
                      systemImage: progress[lesson.id].completed ? "checkmark.seal.fill" : "checkmark.seal")
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .tint(lesson.level.accentColor)
            .disabled(progress[lesson.id].completed)
        }
        .padding(.top, 12)
    }
}

// MARK: - Vocabulary

struct VocabularySection: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson

    private let columns = [
        GridItem(.adaptive(minimum: 260, maximum: 340), spacing: 12)
    ]

    var body: some View {
        SectionCard(title: "Vocabulary · Kelimeler",
                    systemImage: "character.book.closed.fill",
                    tint: lesson.level.accentColor) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(lesson.vocabulary) { item in
                    VocabCard(item: item,
                              mastered: progress[lesson.id].vocabularyMastered.contains(item.turkish),
                              tint: lesson.level.accentColor) {
                        progress.toggleMastered(lessonID: lesson.id,
                                                word: item.turkish,
                                                translation: item.english)
                    }
                }
            }
        }
    }
}

// MARK: - Grammar

struct GrammarSection: View {
    let lesson: Lesson
    let grammar: [GrammarNote]
    let tint: Color

    var body: some View {
        SectionCard(title: "Grammar · Dilbilgisi",
                    systemImage: "text.alignleft",
                    tint: tint) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(grammar) { note in
                    GrammarDetailView(lessonID: lesson.id, note: note, tint: tint)
                }
            }
        }
    }
}

// MARK: - Phrases

struct PhrasesSection: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson
    let phrases: [Phrase]
    let tint: Color

    var body: some View {
        SectionCard(title: "Useful Phrases · Kullanışlı İfadeler",
                    systemImage: "bubble.left.and.bubble.right.fill",
                    tint: tint) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(phrases, id: \.self) { p in
                    PhraseRow(lessonID: lesson.id, phrase: p, tint: tint)
                }
            }
        }
    }
}

private struct PhraseRow: View {
    @EnvironmentObject private var progress: ProgressStore
    let lessonID: String
    let phrase: Phrase
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            PronunciationButton(text: phrase.turkish, tint: tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(phrase.turkish).font(.system(size: 15, weight: .medium))
                Text(phrase.english).font(.subheadline).foregroundStyle(.secondary)
                if let note = phrase.note {
                    Text(note).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
            let studied = progress[lessonID].phrasesStudied.contains(phrase.turkish)
            Button {
                progress.markPhraseStudied(lessonID: lessonID, phrase: phrase.turkish)
            } label: {
                Image(systemName: studied ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(studied ? tint : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .help(studied ? "Studied" : "Mark as studied")
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Exercises

struct ExerciseSection: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson
    let onOpen: (Exercise) -> Void

    var body: some View {
        SectionCard(title: "Exercises · Alıştırmalar",
                    systemImage: "checklist",
                    tint: lesson.level.accentColor) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sırayla çöz: Öğren → Pratik → Sınav. Her adım bir öncekinin tamamlanmasıyla açılır.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
                ForEach(Array(orderedExercises.enumerated()), id: \.element.id) { idx, ex in
                    ExerciseRow(
                        exercise: ex,
                        index: idx,
                        tint: lesson.level.accentColor,
                        completed: progress[lesson.id].exercisesCompleted.contains(ex.id),
                        locked: isLocked(index: idx)
                    ) {
                        guard !isLocked(index: idx) else { return }
                        onOpen(ex)
                    }
                }
            }
        }
    }

    private var orderedExercises: [Exercise] {
        lesson.exercises.sorted { $0.orderRank < $1.orderRank }
    }

    private func isLocked(index: Int) -> Bool {
        guard index > 0 else { return false }
        let previous = orderedExercises[index - 1]
        return !progress[lesson.id].exercisesCompleted.contains(previous.id)
    }
}

private struct ExerciseRow: View {
    let exercise: Exercise
    let index: Int
    let tint: Color
    let completed: Bool
    let locked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(tint.opacity(locked ? 0.08 : 0.18))
                        .frame(width: 36, height: 36)
                    Image(systemName: locked ? "lock.fill" : exercise.systemImage)
                        .foregroundStyle(locked ? .secondary : tint)
                        .font(.title3)
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(stepLabel).font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(exercise.title).font(.headline)
                    }
                    Text(locked ? "Previous step required" : subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if completed {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                }
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(locked ? Color.secondary.opacity(0.3) : Color.clear, lineWidth: 1))
            .opacity(locked ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .disabled(locked)
    }

    private var stepLabel: String {
        switch index {
        case 0: return "ADIM 1 · ÖĞREN"
        case 1: return "ADIM 2 · PRATİK"
        case 2: return "ADIM 3 · SINAV"
        default: return "ADIM \(index + 1)"
        }
    }

    private var subtitle: String {
        switch exercise {
        case .flashcard(let s): return "\(s.cards.count) card\(s.cards.count == 1 ? "" : "s") · +\(XPAward.flashcardCompleted) XP"
        case .multipleChoice: return "Quick check · up to +\(XPAward.multipleChoicePerfect) XP"
        case .fillInBlank:    return "Write the missing word · up to +\(XPAward.fillInBlankPerfect) XP"
        case .listening:      return "Listen and type · up to +\(XPAward.listeningPerfect) XP"
        }
    }
}

// NOTE: SectionCard is defined in Views/Components/Theme.swift.
