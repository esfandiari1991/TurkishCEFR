import Foundation

/// Aggregate gamification state for the player. Encodes/decodes tolerantly
/// so existing persisted snapshots upgrade cleanly when new fields arrive.
struct PlayerStats: Codable, Hashable {
    var totalXP: Int = 0
    var streakDays: Int = 0
    var longestStreak: Int = 0
    var lastStudyDate: Date?
    var lessonsCompleted: Int = 0
    var correctInARow: Int = 0
    var longestCorrectStreak: Int = 0
    var unlockedBadges: Set<String> = []
    /// IDs of badges awarded but not yet shown as a toast to the user.
    var pendingBadgeToasts: [String] = []
    /// Tracks the most recently reached integer level (to detect level-up events).
    var acknowledgedLevel: Int = 1

    // MARK: Rich stats for dashboards / heatmap.
    /// Daily XP keyed by yyyy-MM-dd. Used to render the heatmap.
    var dailyActivity: [String: Int] = [:]
    /// Number of exercise attempts total.
    var exerciseAttempts: Int = 0
    /// Number of exercise attempts that were perfect (first try).
    var exercisePerfectCount: Int = 0
    /// Total number of days the player opened the app.
    var studyDayCount: Int = 0
    /// Approximate total study time in seconds (rough estimate, 90 s per action).
    var studySeconds: Int = 0

    // MARK: Level curve

    /// Quadratic leveling: reach level L at totalXP = (L - 1)^2 * 50.
    static func xpFor(level: Int) -> Int {
        let n = max(0, level - 1)
        return n * n * 50
    }

    static func level(for xp: Int) -> Int {
        let base = (Double(xp) / 50.0).squareRoot()
        return max(1, Int(base.rounded(.down)) + 1)
    }

    var level: Int { Self.level(for: totalXP) }
    var xpAtLevelStart: Int { Self.xpFor(level: level) }
    var xpAtNextLevel: Int { Self.xpFor(level: level + 1) }
    var xpIntoLevel: Int { totalXP - xpAtLevelStart }
    var xpSpanForLevel: Int { max(1, xpAtNextLevel - xpAtLevelStart) }
    var progressInLevel: Double {
        min(1.0, max(0.0, Double(xpIntoLevel) / Double(xpSpanForLevel)))
    }

    var accuracyPercent: Int {
        guard exerciseAttempts > 0 else { return 0 }
        return Int((Double(exercisePerfectCount) / Double(exerciseAttempts)) * 100)
    }

    var humanStudyTime: String {
        let hours = studySeconds / 3600
        let minutes = (studySeconds % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }

    // MARK: Tolerant Codable

    private enum CodingKeys: String, CodingKey {
        case totalXP, streakDays, longestStreak, lastStudyDate, lessonsCompleted
        case correctInARow, longestCorrectStreak, unlockedBadges
        case pendingBadgeToasts, acknowledgedLevel
        case dailyActivity, exerciseAttempts, exercisePerfectCount
        case studyDayCount, studySeconds
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        totalXP                = (try? c.decode(Int.self, forKey: .totalXP)) ?? 0
        streakDays             = (try? c.decode(Int.self, forKey: .streakDays)) ?? 0
        longestStreak          = (try? c.decode(Int.self, forKey: .longestStreak)) ?? 0
        lastStudyDate          = try? c.decode(Date.self, forKey: .lastStudyDate)
        lessonsCompleted       = (try? c.decode(Int.self, forKey: .lessonsCompleted)) ?? 0
        correctInARow          = (try? c.decode(Int.self, forKey: .correctInARow)) ?? 0
        longestCorrectStreak   = (try? c.decode(Int.self, forKey: .longestCorrectStreak)) ?? 0
        unlockedBadges         = (try? c.decode(Set<String>.self, forKey: .unlockedBadges)) ?? []
        pendingBadgeToasts     = (try? c.decode([String].self, forKey: .pendingBadgeToasts)) ?? []
        acknowledgedLevel      = (try? c.decode(Int.self, forKey: .acknowledgedLevel)) ?? 1
        dailyActivity          = (try? c.decode([String: Int].self, forKey: .dailyActivity)) ?? [:]
        exerciseAttempts       = (try? c.decode(Int.self, forKey: .exerciseAttempts)) ?? 0
        exercisePerfectCount   = (try? c.decode(Int.self, forKey: .exercisePerfectCount)) ?? 0
        studyDayCount          = (try? c.decode(Int.self, forKey: .studyDayCount)) ?? 0
        studySeconds           = (try? c.decode(Int.self, forKey: .studySeconds)) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(totalXP, forKey: .totalXP)
        try c.encode(streakDays, forKey: .streakDays)
        try c.encode(longestStreak, forKey: .longestStreak)
        try c.encodeIfPresent(lastStudyDate, forKey: .lastStudyDate)
        try c.encode(lessonsCompleted, forKey: .lessonsCompleted)
        try c.encode(correctInARow, forKey: .correctInARow)
        try c.encode(longestCorrectStreak, forKey: .longestCorrectStreak)
        try c.encode(unlockedBadges, forKey: .unlockedBadges)
        try c.encode(pendingBadgeToasts, forKey: .pendingBadgeToasts)
        try c.encode(acknowledgedLevel, forKey: .acknowledgedLevel)
        try c.encode(dailyActivity, forKey: .dailyActivity)
        try c.encode(exerciseAttempts, forKey: .exerciseAttempts)
        try c.encode(exercisePerfectCount, forKey: .exercisePerfectCount)
        try c.encode(studyDayCount, forKey: .studyDayCount)
        try c.encode(studySeconds, forKey: .studySeconds)
    }
}

/// XP awards in one place so tuning is easy.
enum XPAward {
    static let flashcardCompleted          = 10
    static let phraseStudied               = 3
    static let grammarStudied              = 5
    static let wordMastered                = 2
    static let multipleChoicePerfect       = 15
    static let multipleChoiceWithRetry     = 8
    static let fillInBlankPerfect          = 20
    static let fillInBlankWithRetry        = 12
    static let listeningPerfect            = 25
    static let listeningWithRetry          = 15
    static let lessonCompletionBonus       = 30
}

enum ActivityDateKey {
    private static let fmt: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        return f
    }()
    static func key(for date: Date = Date()) -> String {
        fmt.string(from: Calendar.current.startOfDay(for: date))
    }
}
