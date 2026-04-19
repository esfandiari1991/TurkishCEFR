import SwiftUI

/// Daily challenge: picks a deterministic sentence from the offline corpus,
/// asks the learner to translate it, awards bonus XP on the first correct
/// attempt per day, and pushes the phrase into the SRS deck.
struct DailyChallengeView: View {
    @StateObject private var corpus = CorpusStore.shared
    @EnvironmentObject private var progress: ProgressStore
    @State private var answer: String = ""
    @State private var outcome: Outcome? = nil

    private enum Outcome: Equatable {
        case correct, close, tryAgain
    }

    private var pair: CorpusStore.SentencePair? { corpus.dailySentence() }
    private var alreadyDoneToday: Bool {
        UserDefaults.standard.string(forKey: "dailyChallenge.last")
            == ActivityDateKey.key()
    }

    var body: some View {
        VStack(spacing: 22) {
            header
            if let p = pair {
                question(p)
                if !alreadyDoneToday {
                    answerField(p)
                    outcomeBanner
                } else {
                    VStack(spacing: 8) {
                        Label("You already earned today's bonus XP!", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                        Text("Target answer: \(p.en)")
                            .font(.callout).foregroundStyle(.secondary)
                    }
                }
            } else {
                ProgressView("Loading today's challenge…")
            }
            Spacer(minLength: 0)
        }
        .padding(28)
        .frame(minWidth: 520, minHeight: 440)
        .background(.regularMaterial)
    }

    private var header: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundStyle(BrandTheme.crimson)
            Text("Daily Challenge")
                .font(.title2.weight(.semibold))
            Spacer()
            SoftPill(text: ActivityDateKey.key(),
                     tint: BrandTheme.turquoise)
        }
    }

    private func question(_ p: CorpusStore.SentencePair) -> some View {
        GlassCard(tint: BrandTheme.gold, cornerRadius: 20, padding: 22, intensity: 0.1) {
            VStack(alignment: .leading, spacing: 10) {
                Label("Translate to English", systemImage: "character.book.closed.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(BrandTheme.gold)
                HStack {
                    Text(p.tr)
                        .font(.title3.weight(.semibold))
                    Spacer()
                    Button {
                        Speech.shared.speak(p.tr)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    private func answerField(_ p: CorpusStore.SentencePair) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Type the English translation…", text: $answer, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
            HStack {
                Spacer()
                Button("Check answer") { check(against: p) }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
            }
        }
    }

    @ViewBuilder
    private var outcomeBanner: some View {
        switch outcome {
        case .correct:
            Label("Harika! +30 XP bonus.", systemImage: "star.fill")
                .foregroundStyle(.green)
        case .close:
            Label("Close — check punctuation/spelling and try again.", systemImage: "pencil.tip")
                .foregroundStyle(BrandTheme.gold)
        case .tryAgain:
            Label("Not quite — listen again and try once more.", systemImage: "arrow.counterclockwise")
                .foregroundStyle(.orange)
        case .none:
            EmptyView()
        }
    }

    private func check(against p: CorpusStore.SentencePair) {
        let given = normalize(answer)
        let want = normalize(p.en)
        if given.isEmpty {
            outcome = .tryAgain
            return
        }
        if given == want {
            outcome = .correct
            UserDefaults.standard.set(ActivityDateKey.key(), forKey: "dailyChallenge.last")
            progress.awardXP(30, reason: "Daily challenge")
            SRSStore.shared.enroll(front: p.tr, back: p.en, origin: "daily")
        } else if given.count >= 3 && (given.contains(want) || want.contains(given)) {
            outcome = .close
        } else {
            outcome = .tryAgain
        }
    }

    private func normalize(_ s: String) -> String {
        s.lowercased()
            .replacingOccurrences(of: "[\\p{P}]", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
