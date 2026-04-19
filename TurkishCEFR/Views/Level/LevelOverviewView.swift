import SwiftUI

struct LevelOverviewView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore

    let level: CEFRLevel
    @Binding var selectedLesson: Lesson?

    var lessons: [Lesson] { curriculum.lessons(for: level) }
    var completion: Double { progress.completion(for: lessons) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                stats
                LessonGrid(lessons: lessons, onSelect: { selectedLesson = $0 })
            }
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(GradientBackground(level: level))
        .navigationTitle("\(level.rawValue) · \(level.englishTitle)")
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 20) {
            ZStack {
                Circle()
                    .fill(level.gradient)
                    .frame(width: 88, height: 88)
                    .shadow(color: level.accentColor.opacity(0.4), radius: 16, y: 6)
                Image(systemName: level.systemImage)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("\(level.rawValue) — \(level.englishTitle)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Text(level.title)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(level.summary)
                    .font(.body)
                    .foregroundStyle(.primary.opacity(0.8))
                    .frame(maxWidth: 600, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            ProgressRing(value: completion, tint: level.accentColor)
                .frame(width: 96, height: 96)
        }
    }

    private var stats: some View {
        HStack(spacing: 16) {
            StatCard(title: "Lessons", value: "\(lessons.count)",
                     systemImage: "book.closed.fill", tint: level.accentColor)
            StatCard(title: "Vocabulary",
                     value: "\(lessons.reduce(0) { $0 + $1.vocabulary.count })",
                     systemImage: "character.book.closed.fill",
                     tint: level.accentColor)
            StatCard(title: "Grammar units",
                     value: "\(lessons.reduce(0) { $0 + $1.grammar.count })",
                     systemImage: "text.alignleft",
                     tint: level.accentColor)
            StatCard(title: "Exercises",
                     value: "\(lessons.reduce(0) { $0 + $1.exercises.count })",
                     systemImage: "checklist",
                     tint: level.accentColor)
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3.weight(.bold))
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.06)))
    }
}

private struct LessonGrid: View {
    let lessons: [Lesson]
    let onSelect: (Lesson) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 280, maximum: 360), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(lessons) { lesson in
                Button {
                    onSelect(lesson)
                } label: {
                    LessonCard(lesson: lesson)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct LessonCard: View {
    @EnvironmentObject private var progress: ProgressStore
    let lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ders \(lesson.number)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                if progress[lesson.id].completed {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                }
            }
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: lesson.systemImage)
                    .font(.title)
                    .foregroundStyle(lesson.level.accentColor)
                    .frame(width: 40, height: 40)
                    .background(lesson.level.accentColor.opacity(0.12),
                                in: RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.titleTR)
                        .font(.headline)
                    Text(lesson.titleEN)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            Text(lesson.summary)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
            HStack(spacing: 12) {
                Label("\(lesson.vocabulary.count) words", systemImage: "character.book.closed")
                Label("\(lesson.estimatedMinutes) min", systemImage: "clock")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.08)))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
        .contentShape(Rectangle())
    }
}
