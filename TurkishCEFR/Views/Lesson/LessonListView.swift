import SwiftUI

struct LessonListView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore

    let level: CEFRLevel
    @Binding var selection: Lesson?

    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(curriculum.lessons(for: level)) { lesson in
                    LessonRow(lesson: lesson,
                              score: progress[lesson.id].score,
                              completed: progress[lesson.id].completed)
                        .tag(lesson)
                }
            } header: {
                HStack(spacing: 8) {
                    Image(systemName: level.systemImage)
                        .foregroundStyle(level.accentColor)
                    Text("\(level.rawValue) · \(level.title) (\(level.englishTitle))")
                        .font(.headline)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.inset)
        .navigationTitle(level.rawValue)
    }
}

private struct LessonRow: View {
    let lesson: Lesson
    let score: Double
    let completed: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(lesson.level.accentColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: lesson.systemImage)
                    .foregroundStyle(lesson.level.accentColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(lesson.titleTR)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                Text(lesson.titleEN)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            if completed {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            } else if score > 0 {
                ProgressRing(value: score, tint: lesson.level.accentColor, lineWidth: 3)
                    .frame(width: 18, height: 18)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
