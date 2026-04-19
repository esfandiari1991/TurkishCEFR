import SwiftUI

/// GitHub-style daily activity heatmap. Shows the last `weeks` weeks of
/// study activity as a grid of coloured cells. Darker = more activity that
/// day. Tiles scale smoothly and tooltips show the exact day + activity.
struct HeatmapView: View {
    let weeks: Int
    let dailyActivity: [String: Int]   // key = yyyy-MM-dd
    let tint: Color

    private let cellSize: CGFloat = 13
    private let spacing: CGFloat = 3

    private var today: Date { Calendar.current.startOfDay(for: Date()) }

    private var start: Date {
        let cal = Calendar.current
        // Roll back to the previous Sunday so columns align weekly.
        let weekday = cal.component(.weekday, from: today)   // 1 = Sunday
        let offset = (weekday - 1) + (weeks - 1) * 7
        return cal.date(byAdding: .day, value: -offset, to: today) ?? today
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        return f
    }()

    private static let friendlyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    private var peakValue: Int {
        max(1, dailyActivity.values.max() ?? 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: spacing) {
                ForEach(0..<weeks, id: \.self) { weekIdx in
                    VStack(spacing: spacing) {
                        ForEach(0..<7, id: \.self) { dayIdx in
                            cell(week: weekIdx, day: dayIdx)
                        }
                    }
                }
            }
            legend
        }
    }

    @ViewBuilder
    private func cell(week: Int, day: Int) -> some View {
        let cal = Calendar.current
        let offset = week * 7 + day
        if let date = cal.date(byAdding: .day, value: offset, to: start),
           date <= today {
            let key = Self.dateFormatter.string(from: date)
            let value = dailyActivity[key] ?? 0
            RoundedRectangle(cornerRadius: 3)
                .fill(fill(for: value))
                .frame(width: cellSize, height: cellSize)
                .help("\(Self.friendlyFormatter.string(from: date)) · \(value) XP")
        } else {
            Color.clear.frame(width: cellSize, height: cellSize)
        }
    }

    private func fill(for value: Int) -> Color {
        guard value > 0 else { return Color.secondary.opacity(0.12) }
        let intensity = min(1.0, max(0.2, Double(value) / Double(peakValue)))
        return tint.opacity(0.2 + intensity * 0.8)
    }

    private var legend: some View {
        HStack(spacing: 6) {
            Text("Less").font(.caption2).foregroundStyle(.secondary)
            ForEach([0, 1, 2, 3, 4], id: \.self) { lv in
                RoundedRectangle(cornerRadius: 3)
                    .fill(fill(for: lv == 0 ? 0 : peakValue * lv / 4))
                    .frame(width: cellSize, height: cellSize)
            }
            Text("More").font(.caption2).foregroundStyle(.secondary)
        }
    }
}
