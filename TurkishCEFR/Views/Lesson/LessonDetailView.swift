import SwiftUI

struct LessonDetailView: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson

    @State private var selectedExercise: Exercise?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header

                if !lesson.vocabulary.isEmpty {
                    VocabularySection(lesson: lesson)
                }
                if !lesson.grammar.isEmpty {
                    GrammarSection(grammar: lesson.grammar, tint: lesson.level.accentColor)
                }
                if !lesson.phrases.isEmpty {
                    PhrasesSection(phrases: lesson.phrases, tint: lesson.level.accentColor)
                }
                if !lesson.exercises.isEmpty {
                    ExerciseSection(lesson: lesson, onOpen: { selectedExercise = $0 })
                }

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

struct VocabularySection: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson

    private let columns = [
        GridItem(.adaptive(minimum: 240, maximum: 320), spacing: 12)
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
                        progress.toggleMastered(lessonID: lesson.id, word: item.turkish)
                    }
                }
            }
        }
    }
}

struct VocabCard: View {
    let item: VocabularyItem
    let mastered: Bool
    let tint: Color
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(item.turkish)
                        .font(.system(size: 15, weight: .semibold))
                    Text(item.partOfSpeech.label)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 1)
                        .background(tint.opacity(0.15), in: Capsule())
                        .foregroundStyle(tint)
                }
                Text(item.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let tr = item.exampleTR, let en = item.exampleEN {
                    Text("“\(tr)” — \(en)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
            }
            Spacer()
            Button(action: onToggle) {
                Image(systemName: mastered ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(mastered ? tint : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .help(mastered ? "Mastered — click to unset" : "Mark as mastered")
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.06)))
    }
}

struct GrammarSection: View {
    let grammar: [GrammarNote]
    let tint: Color

    var body: some View {
        SectionCard(title: "Grammar · Dilbilgisi",
                    systemImage: "text.alignleft",
                    tint: tint) {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(grammar) { note in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.explanation)
                            .font(.body)
                            .foregroundStyle(.primary.opacity(0.85))
                        if !note.examples.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(note.examples, id: \.self) { ex in
                                    HStack(alignment: .top, spacing: 10) {
                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                            .foregroundStyle(tint)
                                            .padding(.top, 4)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(ex.turkish).font(.callout.weight(.medium))
                                            Text(ex.english).font(.caption).foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            .padding(12)
                            .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    if note.id != grammar.last?.id {
                        Divider()
                    }
                }
            }
        }
    }
}

struct PhrasesSection: View {
    let phrases: [Phrase]
    let tint: Color

    var body: some View {
        SectionCard(title: "Useful Phrases · Kullanışlı İfadeler",
                    systemImage: "bubble.left.and.bubble.right.fill",
                    tint: tint) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(phrases, id: \.self) { p in
                    HStack(alignment: .top, spacing: 12) {
                        PronunciationButton(text: p.turkish, tint: tint)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(p.turkish).font(.system(size: 15, weight: .medium))
                            Text(p.english).font(.subheadline).foregroundStyle(.secondary)
                            if let note = p.note {
                                Text(note).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding(10)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

struct ExerciseSection: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson
    let onOpen: (Exercise) -> Void

    var body: some View {
        SectionCard(title: "Exercises · Alıştırmalar",
                    systemImage: "checklist",
                    tint: lesson.level.accentColor) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(lesson.exercises, id: \.id) { ex in
                    Button { onOpen(ex) } label: {
                        HStack(spacing: 12) {
                            Image(systemName: ex.systemImage)
                                .font(.title3)
                                .foregroundStyle(lesson.level.accentColor)
                                .frame(width: 32, height: 32)
                                .background(lesson.level.accentColor.opacity(0.12),
                                            in: RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ex.title).font(.headline)
                                Text(subtitle(for: ex)).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if progress[lesson.id].exercisesCompleted.contains(ex.id) {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                            }
                            Image(systemName: "chevron.right").foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func subtitle(for ex: Exercise) -> String {
        switch ex {
        case .flashcard(let s): return "\(s.cards.count) card\(s.cards.count == 1 ? "" : "s")"
        case .multipleChoice: return "Quick check"
        case .fillInBlank: return "Write the missing word"
        }
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    let systemImage: String
    let tint: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.title3.weight(.semibold))
            }
            content()
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.08)))
        .shadow(color: .black.opacity(0.06), radius: 18, y: 6)
    }
}
