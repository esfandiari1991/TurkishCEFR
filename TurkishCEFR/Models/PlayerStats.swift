import Foundation

/// Aggregate gamification state for the player.
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

    // MARK: Level curve

    /// Quadratic leveling: reach level L at totalXP = (L - 1)^2 * 50.
    static func xpFor(level: Int) -> Int {
        let n = max(0, level - 1)
        return n * n * 50
    }

    static func level(for xp: Int) -> Int {
        // inverse of xpFor(level:)
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
    static let lessonCompletionBonus       = 30
}
