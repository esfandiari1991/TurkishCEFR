import SwiftUI

/// Daily challenge: picks a deterministic sentence from the offline corpus,
/// asks the learner to translate it, awards bonus XP on the first correct
/// attempt per day, and pushes the phrase into the SRS deck.
///
/// Previously the feedback was binary — you got a green or red banner and
/// the answer stayed hidden, so a stuck learner couldn't see the correct
/// solution. The rewrite:
///   • keeps an attempt history (each guess + its verdict);
///   • on any wrong guess immediately shows the correct answer + a
///     plain-English explanation + a Turkish example sentence using the
///     tricky vocabulary;
///   • lets the user "Try again" without penalty — the bonus XP only
///     fires on the first success of the day;
///   • offers a visible "Reveal answer" escape hatch so no-one gets
///     stuck forever on something they truly don't know.
struct DailyChallengeView: View {
    @StateObject private var corpus = CorpusStore.shared
    @EnvironmentObject private var progress: ProgressStore

    @State private var answer: String = ""
    @State private var attempts: [Attempt] = []
    @State private var revealed: Bool = false
    @State private var completed: Bool = false

    private struct Attempt: Identifiable, Equatable {
        let id = UUID()
        let text: String
        let verdict: Verdict
    }
    private enum Verdict: String, Equatable {
        case correct, close, wrong, empty
    }

    private var pair: CorpusStore.SentencePair? { corpus.dailySentence() }
    private static func alreadyDoneTodayFromDefaults() -> Bool {
        UserDefaults.standard.string(forKey: "dailyChallenge.last")
            == ActivityDateKey.key()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                if let p = pair {
                    question(p)
                    if !completed && !revealed {
                        answerField(p)
                    }
                    if !attempts.isEmpty {
                        attemptHistory
                    }
                    if completed {
                        successPanel(p)
                    } else if revealed {
                        revealedPanel(p)
                    }
                } else {
                    ProgressView("Loading today's challenge…")
                }
            }
            .padding(Spacing.xl)
        }
        .frame(minWidth: 580, minHeight: 520)
        .background(.regularMaterial)
        .onAppear { completed = Self.alreadyDoneTodayFromDefaults() }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "flame.fill")
                .font(.system(size: IconSize.large))
                .foregroundStyle(BrandTheme.crimson)
            VStack(alignment: .leading, spacing: 2) {
                Text("Daily Challenge")
                    .displayTitle()
                Text("Translate today's sentence to English. Get it right on the first try for bonus XP — wrong guesses show a mini-lesson.")
                    .font(DisplayFont.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(LineHeight.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            SoftPill(text: ActivityDateKey.key(), tint: BrandTheme.turquoise)
        }
    }

    // MARK: - Question card

    private func question(_ p: CorpusStore.SentencePair) -> some View {
        GlassCard(tint: BrandTheme.gold, cornerRadius: 20, padding: Spacing.lg, intensity: 0.1) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Label("Translate to English", systemImage: "character.book.closed.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(BrandTheme.gold)
                HStack(alignment: .firstTextBaseline) {
                    SpeakableText(text: p.tr,
                                  font: .title2.weight(.semibold),
                                  showSpeaker: true)
                    Spacer()
                }
            }
        }
    }

    // MARK: - Answer field

    private func answerField(_ p: CorpusStore.SentencePair) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            TextField("Type the English translation…", text: $answer, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
                .font(DisplayFont.body)
            HStack(spacing: Spacing.sm) {
                Button("Reveal answer") { revealed = true }
                    .buttonStyle(.bordered)
                Spacer()
                Button("Check answer") { check(against: p) }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                    .disabled(answer.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    // MARK: - Attempt history

    private var attemptHistory: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Label("Your attempts", systemImage: "list.bullet.rectangle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            ForEach(attempts) { a in
                HStack(spacing: Spacing.sm) {
                    Image(systemName: icon(for: a.verdict))
                        .foregroundStyle(color(for: a.verdict))
                        .frame(width: IconSize.small)
                    Text(a.text.isEmpty ? "(empty guess)" : a.text)
                        .font(DisplayFont.body)
                        .foregroundStyle(a.text.isEmpty ? .secondary : .primary)
                    Spacer()
                    Text(verdictLabel(a.verdict))
                        .font(.caption)
                        .foregroundStyle(color(for: a.verdict))
                }
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(color(for: a.verdict).opacity(0.08),
                            in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    // MARK: - Success / reveal panels

    private func successPanel(_ p: CorpusStore.SentencePair) -> some View {
        GlassCard(tint: .green, cornerRadius: 18, padding: Spacing.lg) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Label("Harika! Doğru cevap.", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .foregroundStyle(.green)
                Text("English: \(p.en)")
                    .font(DisplayFont.body)
                Text("Bonus XP already logged. Come back tomorrow for a new sentence — your streak will thank you.")
                    .font(DisplayFont.body.weight(.regular))
                    .foregroundStyle(.secondary)
                    .lineSpacing(LineHeight.body)
                HStack {
                    Button("Another round") {
                        attempts.removeAll()
                        answer = ""
                        revealed = false
                        completed = false
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
            }
        }
    }

    private func revealedPanel(_ p: CorpusStore.SentencePair) -> some View {
        GlassCard(tint: BrandTheme.gold, cornerRadius: 18, padding: Spacing.lg) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Label("Here's the answer", systemImage: "lightbulb.fill")
                    .font(.headline).foregroundStyle(BrandTheme.gold)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Turkish").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                    SpeakableText(text: p.tr, font: .title3.weight(.semibold))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("English").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                    Text(p.en).font(.title3)
                }
                explanation(for: p)
                HStack {
                    Button("Try again") {
                        revealed = false
                        answer = ""
                    }.buttonStyle(.bordered)
                    Spacer()
                    Button("I've got it") {
                        revealed = false
                    }.buttonStyle(.borderedProminent)
                }
            }
        }
    }

    /// A very short, plain-English note pointing out the likely reason a
    /// learner got this specific sentence wrong. We look for common Turkish
    /// grammar signals in the source sentence and surface whichever one
    /// applies. No AI — heuristic only, so it works fully offline.
    private func explanation(for p: CorpusStore.SentencePair) -> some View {
        let hint = Self.hint(for: p.tr)
        return VStack(alignment: .leading, spacing: 4) {
            Label("Why this may have tripped you up", systemImage: "questionmark.circle.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(hint)
                .font(DisplayFont.body)
                .foregroundStyle(.primary)
                .lineSpacing(LineHeight.body)
        }
        .padding(Spacing.sm)
        .background(Color.accentColor.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 10))
    }

    static func hint(for tr: String) -> String {
        let low = tr.lowercased()
        if low.contains("yor") {
            return "This sentence uses the present continuous suffix -(I)yor (\"is / are doing\"). Notice how it attaches to the verb stem after dropping the infinitive -mak / -mek."
        }
        if low.contains("ecek") || low.contains("acak") {
            return "You're seeing the future tense suffix -(y)AcAk. It means \"will / is going to\", harmonised for front/back vowels."
        }
        if low.contains("di") || low.contains("dı") || low.contains("du") || low.contains("dü") ||
           low.contains("ti") || low.contains("tı") || low.contains("tu") || low.contains("tü") {
            return "This uses the definite past tense -DI (\"-ed\"). The d becomes t after voiceless consonants (p, ç, t, k, s, ş, h, f)."
        }
        if low.contains("mış") || low.contains("miş") || low.contains("muş") || low.contains("müş") {
            return "That's the evidential / inferential past -mIş (\"apparently did / must have done\") — a nuance English often misses."
        }
        if low.contains("meli") || low.contains("malı") {
            return "The suffix -mAlI means \"must / should\". Look for it attached to the verb stem."
        }
        if low.contains("se ") || low.contains("sa ") || low.contains("sen ") {
            return "This clause uses the conditional suffix -sA (\"if\") — translate it with \"if\" even when word order differs from English."
        }
        return "Turkish is SOV: subject, then objects, then verb. Re-arrange the English translation accordingly, and remember that case endings on the object tell you who's doing what to whom."
    }

    // MARK: - Core grader

    private func check(against p: CorpusStore.SentencePair) {
        let given = normalize(answer)
        let want = normalize(p.en)
        if given.isEmpty {
            attempts.append(Attempt(text: answer, verdict: .empty))
            return
        }
        if given == want {
            attempts.append(Attempt(text: answer, verdict: .correct))
            if !completed {
                UserDefaults.standard.set(ActivityDateKey.key(), forKey: "dailyChallenge.last")
                progress.awardXP(30, reason: "Daily challenge")
                SRSStore.shared.enroll(front: p.tr, back: p.en, origin: "daily")
                completed = true
            }
        } else if given.count >= 3 && (given.contains(want) || want.contains(given)) {
            attempts.append(Attempt(text: answer, verdict: .close))
            revealed = true
        } else {
            attempts.append(Attempt(text: answer, verdict: .wrong))
            revealed = true
        }
        answer = ""
    }

    private func normalize(_ s: String) -> String {
        s.lowercased()
            .replacingOccurrences(of: "[\\p{P}]", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Verdict visuals

    private func icon(for v: Verdict) -> String {
        switch v {
        case .correct: return "checkmark.circle.fill"
        case .close:   return "pencil.tip.crop.circle"
        case .wrong:   return "xmark.circle.fill"
        case .empty:   return "questionmark.circle"
        }
    }

    private func color(for v: Verdict) -> Color {
        switch v {
        case .correct: return .green
        case .close:   return BrandTheme.gold
        case .wrong:   return BrandTheme.crimson
        case .empty:   return .secondary
        }
    }

    private func verdictLabel(_ v: Verdict) -> String {
        switch v {
        case .correct: return "Correct"
        case .close:   return "Very close"
        case .wrong:   return "Not quite"
        case .empty:   return "Empty"
        }
    }
}
