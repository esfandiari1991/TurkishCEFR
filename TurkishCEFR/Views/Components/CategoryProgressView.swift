import SwiftUI

/// A 2×2 grid of progress bars for Vocabulary / Grammar / Phrases / Exercises.
struct CategoryProgressGrid: View {
    let lesson: Lesson
    let tint: Color
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)],
                  spacing: 12) {
            ForEach(CategoryKind.allCases) { kind in
                let p = progress[lesson.id].progress(in: lesson, kind: kind)
                let c = progress[lesson.id].categoryCount(in: lesson, kind: kind)
                CategoryProgressRow(kind: kind, tint: tint,
                                    progress: p, done: c.done, total: c.total)
            }
        }
    }
}

/// One labeled bar. Used both per-lesson and aggregated per-level.
struct CategoryProgressRow: View {
    let kind: CategoryKind
    let tint: Color
    let progress: Double
    let done: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: kind.systemImage)
                    .foregroundStyle(tint)
                Text(kind.title)
                    .font(.callout.weight(.semibold))
                Text("· \(kind.turkishTitle)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(done)/\(total)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(tint.opacity(0.15))
                    Capsule()
                        .fill(tint.gradient)
                        .frame(width: max(4, geo.size.width * progress))
                        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: progress)
                }
            }
            .frame(height: 8)
            HStack(spacing: 4) {
                Text(percent)
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
                if progress >= 0.999 {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                        .font(.caption2)
                }
            }
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.05)))
    }

    private var percent: String {
        "\(Int((progress * 100).rounded()))%"
    }
}

/// Aggregate grid used on LevelOverviewView — no per-lesson numbers, just averages.
struct LevelCategoryProgressGrid: View {
    let lessons: [Lesson]
    let tint: Color
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)],
                  spacing: 12) {
            ForEach(CategoryKind.allCases) { kind in
                let value = progress.category(for: lessons, kind)
                let totals = aggregate(for: kind)
                CategoryProgressRow(kind: kind, tint: tint,
                                    progress: value,
                                    done: totals.done,
                                    total: totals.total)
            }
        }
    }

    private func aggregate(for kind: CategoryKind) -> (done: Int, total: Int) {
        var done = 0, total = 0
        for lesson in lessons {
            let c = progress[lesson.id].categoryCount(in: lesson, kind: kind)
            done += c.done
            total += c.total
        }
        return (done, total)
    }
}
