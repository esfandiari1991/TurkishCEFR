import SwiftUI

/// Auto-generated end-of-week summary. Surfaces the one stat the learner
/// wants to see (total XP this week) plus the two they need to see
/// (longest streak maintained, weakest words to review). Designed to be
/// shown on Sundays but accessible any time via the sidebar.
struct WeeklyRecapView: View {
    @EnvironmentObject private var progress: ProgressStore
    @ObservedObject private var journal = StudyJournalStore.shared
    @ObservedObject private var srs = SRSStore.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header

                HStack(alignment: .top, spacing: Spacing.md) {
                    bigStat(title: "XP this week",
                            value: "\(weekXP)",
                            systemImage: "bolt.fill",
                            tint: BrandTheme.gold)
                    bigStat(title: "Longest streak",
                            value: "\(longestWeeklyStreak) day\(longestWeeklyStreak == 1 ? "" : "s")",
                            systemImage: "flame.fill",
                            tint: BrandTheme.crimson)
                    bigStat(title: "New words",
                            value: "\(newWordsThisWeek)",
                            systemImage: "character.book.closed.fill",
                            tint: BrandTheme.turquoise)
                }

                studiedRecentlyCard
                weakestCard
                nextStepCard

                Spacer(minLength: 0)
            }
            .padding(Spacing.xl)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your week at a glance")
                .displayTitle()
            Text(recapWindowLabel)
                .font(DisplayFont.body)
                .foregroundStyle(.secondary)
        }
    }

    private var recapWindowLabel: String {
        let now = Date()
        let cal = Calendar.current
        let start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now)) ?? now
        let f = DateFormatter()
        f.dateStyle = .medium
        return "\(f.string(from: start)) → \(f.string(from: now))"
    }

    // MARK: - Stats cards

    private func bigStat(title: String, value: String, systemImage: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(RoundedRectangle(cornerRadius: 14).fill(.regularMaterial))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(tint.opacity(0.25), lineWidth: 1))
    }

    private var studiedRecentlyCard: some View {
        SectionCard(tint: BrandTheme.turquoise) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Label("Lessons you touched", systemImage: "book.fill")
                    .font(.headline)
                    .foregroundStyle(BrandTheme.turquoise)
                if weekEntries.isEmpty {
                    Text("You didn't touch a lesson this week. Open the sidebar and start any A1 topic — it only takes 5 minutes to keep your streak.")
                        .font(DisplayFont.body)
                        .foregroundStyle(.secondary)
                } else {
                    FlowLayout(spacing: 6) {
                        ForEach(Array(lessonsTouchedThisWeek), id: \.self) { title in
                            SoftPill(text: title, tint: BrandTheme.turquoise)
                        }
                    }
                }
            }
        }
    }

    private var weakestCard: some View {
        SectionCard(tint: BrandTheme.crimson) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Label("Words you keep forgetting", systemImage: "exclamationmark.bubble.fill")
                    .font(.headline)
                    .foregroundStyle(BrandTheme.crimson)
                if weakestCards.isEmpty {
                    Text("Nothing to worry about — your review deck is clean.")
                        .font(DisplayFont.body)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(weakestCards) { card in
                            HStack {
                                Text(card.front)
                                    .font(.system(size: 16, weight: .semibold))
                                Text("— \(card.back)")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(card.lapses) lapse\(card.lapses == 1 ? "" : "s")")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                }
            }
        }
    }

    private var nextStepCard: some View {
        SectionCard(tint: BrandTheme.gold) {
            HStack(alignment: .top, spacing: Spacing.md) {
                Image(systemName: "map.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(BrandTheme.gold)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Suggested for next week")
                        .font(.headline)
                    Text(suggestion)
                        .font(DisplayFont.body)
                        .lineSpacing(LineHeight.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    // MARK: - Derived values

    private var weekEntries: [StudyJournalStore.Entry] {
        let cal = Calendar.current
        let cutoff = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: .init())) ?? .init()
        return journal.sortedEntries.filter { $0.date >= cutoff }
    }

    private var weekXP: Int {
        weekEntries.reduce(0) { $0 + $1.xpEarned }
    }

    private var newWordsThisWeek: Int {
        weekEntries.reduce(0) { $0 + $1.wordsMastered.count }
    }

    private var lessonsTouchedThisWeek: [String] {
        Array(Set(weekEntries.flatMap { $0.lessonTitles })).sorted()
    }

    private var longestWeeklyStreak: Int {
        let cal = Calendar.current
        let keys = Set(weekEntries.map { $0.dayKey })
        guard !keys.isEmpty else { return 0 }
        var longest = 0
        var running = 0
        for offset in 0..<7 {
            let day = cal.date(byAdding: .day, value: -offset, to: .init())!
            let k = ActivityDateKey.key(for: day)
            if keys.contains(k) {
                running += 1
                longest = max(longest, running)
            } else {
                running = 0
            }
        }
        return longest
    }

    private var weakestCards: [SRSStore.Card] {
        srs.cards.filter { $0.lapses > 0 }
            .sorted { $0.lapses > $1.lapses }
            .prefix(5)
            .map { $0 }
    }

    private var suggestion: String {
        if weekXP == 0 {
            return "Open any A1 lesson and spend five minutes on it — even one lesson per week is enough to keep vocabulary alive."
        }
        if longestWeeklyStreak >= 5 {
            return "You're on a roll — try a B1 grammar tutorial next week and challenge yourself with one dictation exercise per day."
        }
        if newWordsThisWeek < 5 {
            return "Try to add five new words this coming week. Use the Dictionary (Offline mode) to browse the frequency list."
        }
        return "Consistency is the magic ingredient. Target a short session every day rather than one long one."
    }
}
