import SwiftUI

/// Interactive Vowel-Harmony Lab.
///
/// Turkish is an agglutinative language whose suffixes are shaped by two
/// orthogonal vowel-harmony axes:
///
///   • **Front vs Back** (tongue position) — determines whether `a/e`,
///     `ı/i`, `o/ö`, `u/ü` is chosen.
///   • **Rounded vs Unrounded** (lip rounding) — only relevant for the
///     4-way "I-type" minor harmony.
///
/// Learners often memorise the suffix tables without ever internalising
/// the geometry; this Lab makes the geometry tangible. Every Turkish
/// vowel becomes a tappable chip arranged on a 2-axis grid, and tapping
/// one (a) plays its native pronunciation, (b) lights up every vowel in
/// the same harmony group, (c) shows the suffix tables that follow it,
/// and (d) generates a live example word.
///
/// Two quick drills round it out:
///   • **A-type harmony (2-way)** — pick `-lar` vs `-ler` for a stem.
///   • **I-type harmony (4-way)** — pick `-ı / -i / -u / -ü` for a stem.
///
/// Each correct answer is worth XP so the lab participates in the
/// regular gamification loop.
struct VowelHarmonyLabView: View {
    @EnvironmentObject private var progress: ProgressStore
    @ObservedObject private var speech = Speech.shared

    @State private var selected: TurkishVowel = .a
    @State private var drill: Drill = .aType
    @State private var drillPrompt: DrillPrompt = DrillPrompt.random(for: .aType)
    @State private var lastResult: DrillResult? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                vowelMap
                selectedDetail
                divider
                drillSection
            }
            .padding(Spacing.xl)
        }
        .background(GradientBackground())
        .navigationTitle(AppSection.Tool.harmony.title)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Ünlü Uyumu Laboratuvarı")
                .turkishDisplayTitle()
            Text("Vowel Harmony Lab")
                .displayTitle()
                .foregroundStyle(.secondary)
            Text(
                "Turkish suffixes reshape themselves to match the last vowel of the " +
                "stem. Tap any vowel below to hear it, see its harmony group light " +
                "up, and watch the suffixes it commands. Then try the drills."
            )
            .readableBody()
            .frame(maxWidth: 760, alignment: .leading)
        }
    }

    // MARK: - Vowel map

    /// 4×2 grid: rows = back / front, columns = unrounded / rounded.
    /// This mirrors the IPA vowel chart so learners internalise the
    /// tongue-position geometry rather than rote-memorise.
    private var vowelMap: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("The 8 Turkish vowels")
                .sectionTitle()
            VStack(spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    axisLabel("")
                    axisLabel("Unrounded · Yuvarlak değil")
                    axisLabel("Rounded · Yuvarlak")
                }
                row(title: "Back · Kalın",  vowels: [.a, .ı, .o, .u])
                row(title: "Front · İnce",  vowels: [.e, .i, .ö, .ü])
            }
            .padding(Spacing.md)
            .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
        }
    }

    private func axisLabel(_ text: String) -> some View {
        Text(text)
            .font(DisplayFont.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(title: String, vowels: [TurkishVowel]) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(title)
                .font(DisplayFont.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 140, alignment: .leading)
            ForEach(vowels) { vowel in
                VowelChip(
                    vowel: vowel,
                    isSelected: vowel == selected,
                    isHighlighted: selected.harmonyGroup == vowel.harmonyGroup && vowel != selected
                ) {
                    selected = vowel
                    speech.speak(vowel.display)
                }
            }
        }
    }

    // MARK: - Selected detail

    private var selectedDetail: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Text(selected.display)
                    .font(.system(size: 68, weight: .heavy, design: .serif))
                    .foregroundStyle(BrandTheme.crimson)
                VStack(alignment: .leading, spacing: 4) {
                    Text(selected.groupName)
                        .font(DisplayFont.card)
                    Text("Harmony group: \(selected.harmonyGroup.displayName)")
                        .foregroundStyle(.secondary)
                    Text("IPA: /\(selected.ipa)/")
                        .font(.system(.callout, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    speech.speak(selected.display)
                } label: {
                    Label("Listen", systemImage: "speaker.wave.2.fill")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                }
                .buttonStyle(.borderedProminent)
                .tint(BrandTheme.turquoise)
                .help("Play this vowel · native voice")
            }
            suffixTables
            exampleWord
        }
        .padding(Spacing.lg)
        .background(RoundedRectangle(cornerRadius: 18).fill(.regularMaterial))
    }

    private var suffixTables: some View {
        HStack(alignment: .top, spacing: Spacing.lg) {
            suffixColumn(
                title: "Plural (-lAr) · A-type",
                note: "Back vowels pick -lar, front vowels pick -ler.",
                suffix: selected.harmonyGroup.isBack ? "-lar" : "-ler"
            )
            suffixColumn(
                title: "Accusative (-I) · I-type",
                note: "Matches front/back AND rounded/unrounded of the vowel.",
                suffix: "-" + selected.iTypeSuffix
            )
        }
    }

    private func suffixColumn(title: String, note: String, suffix: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title).font(DisplayFont.strong)
            Text(suffix)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(BrandTheme.turquoise)
            Text(note).font(.callout).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.04)))
    }

    private var exampleWord: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "text.book.closed")
                .foregroundStyle(BrandTheme.gold)
            Text("Example").font(DisplayFont.strong)
            Spacer()
            Button {
                speech.speak(selected.exampleWord)
            } label: {
                Text(selected.exampleWord + "  →  " + selected.exampleTranslation)
                    .font(DisplayFont.card)
            }
            .buttonStyle(.plain)
            .help("Tap to hear this word aloud")
        }
        .padding(Spacing.sm)
        .background(RoundedRectangle(cornerRadius: 12).fill(BrandTheme.gold.opacity(0.1)))
    }

    private var divider: some View {
        Rectangle()
            .fill(.tertiary)
            .frame(height: 1)
            .padding(.vertical, Spacing.xs)
    }

    // MARK: - Drill

    private var drillSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Practice drill").sectionTitle()
                Spacer()
                Picker("", selection: $drill) {
                    ForEach(Drill.allCases) { d in
                        Text(d.title).tag(d)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 300)
                .onChange(of: drill) { _, newValue in
                    drillPrompt = DrillPrompt.random(for: newValue)
                    lastResult = nil
                }
            }

            Text(drillPrompt.question)
                .font(DisplayFont.card)
                .padding(Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))

            HStack(spacing: Spacing.sm) {
                ForEach(drillPrompt.choices, id: \.self) { choice in
                    Button {
                        evaluate(choice: choice)
                    } label: {
                        Text(choice)
                            .font(DisplayFont.strong)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.sm)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint(for: choice))
                }
            }

            if let result = lastResult {
                Text(result.feedback)
                    .font(DisplayFont.body)
                    .foregroundStyle(result.correct ? Color.green : Color.red)
                    .padding(Spacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(result.correct ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    )
                Button("Next prompt") {
                    drillPrompt = DrillPrompt.random(for: drill)
                    lastResult = nil
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(Spacing.lg)
        .background(RoundedRectangle(cornerRadius: 18).fill(.regularMaterial))
    }

    private func evaluate(choice: String) {
        let correct = choice == drillPrompt.correct
        if correct {
            progress.awardXP(5, reason: "Vowel Harmony Lab")
        }
        lastResult = DrillResult(
            correct: correct,
            feedback: correct
                ? "Doğru! \(drillPrompt.explanation)"
                : "Yanlış. Cevap: \(drillPrompt.correct). \(drillPrompt.explanation)",
            picked: choice
        )
        // Strip the leading hyphen from the suffix display string before
        // speaking — we show "-lar" / "-ı" in the UI for clarity, but TTS
        // would otherwise pronounce the hyphen as a pause or read it aloud.
        let spoken = drillPrompt.stem + drillPrompt.correct.replacingOccurrences(of: "-", with: "")
        speech.speak(spoken)
    }

    private func tint(for choice: String) -> Color {
        guard let result = lastResult else { return BrandTheme.turquoise }
        if choice == drillPrompt.correct { return .green }
        if !result.correct && choice == result.picked { return .red }
        return BrandTheme.turquoise.opacity(0.4)
    }
}

// MARK: - Supporting types

private enum TurkishVowel: String, Identifiable, CaseIterable {
    case a, e, ı, i, o, ö, u, ü
    var id: String { rawValue }
    var display: String { rawValue }

    var harmonyGroup: HarmonyGroup {
        switch self {
        case .a, .ı: return .backUnrounded
        case .o, .u: return .backRounded
        case .e, .i: return .frontUnrounded
        case .ö, .ü: return .frontRounded
        }
    }

    var groupName: String {
        switch self {
        case .a: return "Kalın düz · a"
        case .e: return "İnce düz · e"
        case .ı: return "Kalın düz · ı"
        case .i: return "İnce düz · i"
        case .o: return "Kalın yuvarlak · o"
        case .ö: return "İnce yuvarlak · ö"
        case .u: return "Kalın yuvarlak · u"
        case .ü: return "İnce yuvarlak · ü"
        }
    }

    var ipa: String {
        switch self {
        case .a: return "ɑ"
        case .e: return "e"
        case .ı: return "ɯ"
        case .i: return "i"
        case .o: return "o"
        case .ö: return "œ"
        case .u: return "u"
        case .ü: return "y"
        }
    }

    var iTypeSuffix: String {
        switch harmonyGroup {
        case .backUnrounded:  return "ı"
        case .frontUnrounded: return "i"
        case .backRounded:    return "u"
        case .frontRounded:   return "ü"
        }
    }

    var exampleWord: String {
        switch self {
        case .a: return "kitap"
        case .e: return "ev"
        case .ı: return "kız"
        case .i: return "resim"
        case .o: return "yol"
        case .ö: return "göz"
        case .u: return "okul"
        case .ü: return "gün"
        }
    }

    var exampleTranslation: String {
        switch self {
        case .a: return "book"
        case .e: return "house"
        case .ı: return "girl"
        case .i: return "picture"
        case .o: return "road"
        case .ö: return "eye"
        case .u: return "school"
        case .ü: return "day"
        }
    }
}

private enum HarmonyGroup: Hashable {
    case backUnrounded, backRounded, frontUnrounded, frontRounded

    var isBack: Bool { self == .backUnrounded || self == .backRounded }
    var isRounded: Bool { self == .backRounded || self == .frontRounded }

    var displayName: String {
        switch self {
        case .backUnrounded:  return "Back · Unrounded (a, ı)"
        case .backRounded:    return "Back · Rounded (o, u)"
        case .frontUnrounded: return "Front · Unrounded (e, i)"
        case .frontRounded:   return "Front · Rounded (ö, ü)"
        }
    }
}

private struct VowelChip: View {
    let vowel: TurkishVowel
    let isSelected: Bool
    let isHighlighted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(vowel.display)
                .font(.system(size: 30, weight: .heavy, design: .serif))
                .frame(maxWidth: .infinity, minHeight: 54)
                .foregroundStyle(foreground)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(background)
                        .shadow(color: .black.opacity(isSelected ? 0.2 : 0.05), radius: isSelected ? 8 : 2, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(borderColor, lineWidth: isSelected ? 3 : 1)
                )
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isSelected)
                .animation(.easeInOut(duration: 0.25), value: isHighlighted)
        }
        .buttonStyle(.plain)
        .help(vowel.groupName)
    }

    private var background: Color {
        if isSelected { return BrandTheme.crimson }
        if isHighlighted { return BrandTheme.turquoise.opacity(0.22) }
        return Color.black.opacity(0.04)
    }

    private var foreground: Color {
        isSelected ? .white : .primary
    }

    private var borderColor: Color {
        if isSelected { return BrandTheme.crimson }
        if isHighlighted { return BrandTheme.turquoise }
        return .clear
    }
}

private enum Drill: String, CaseIterable, Identifiable {
    case aType, iType
    var id: String { rawValue }
    var title: String {
        switch self {
        case .aType: return "Plural (-lAr)"
        case .iType: return "Accusative (-I)"
        }
    }
}

private struct DrillPrompt: Equatable {
    let stem: String
    let gloss: String
    let correct: String
    let choices: [String]
    let explanation: String
    let drill: Drill

    var question: String {
        switch drill {
        case .aType:
            return "Which plural suffix attaches to \"\(stem)\" (\(gloss))?"
        case .iType:
            return "Which accusative suffix attaches to \"\(stem)\" (\(gloss))?"
        }
    }

    static func random(for drill: Drill) -> DrillPrompt {
        switch drill {
        case .aType:
            let pool: [(stem: String, gloss: String, last: TurkishVowel)] = [
                ("kitap", "book", .a),
                ("ev", "house", .e),
                ("öğrenci", "student", .i),
                ("okul", "school", .u),
                ("göl", "lake", .ö),
                ("yol", "road", .o),
                ("kız", "girl", .ı),
                ("gün", "day", .ü),
            ]
            let pick = pool.randomElement()!
            let correct = pick.last.harmonyGroup.isBack ? "-lar" : "-ler"
            return DrillPrompt(
                stem: pick.stem,
                gloss: pick.gloss,
                correct: correct,
                choices: ["-lar", "-ler"],
                explanation: pick.last.harmonyGroup.isBack
                    ? "Last vowel '\(pick.last.display)' is back → plural takes -lar."
                    : "Last vowel '\(pick.last.display)' is front → plural takes -ler.",
                drill: .aType
            )
        case .iType:
            let pool: [(stem: String, gloss: String, last: TurkishVowel)] = [
                ("kitabı", "book (ACC)", .a),
                ("evi", "house (ACC)", .e),
                ("okulu", "school (ACC)", .u),
                ("gözü", "eye (ACC)", .ö),
                ("kızı", "girl (ACC)", .ı),
                ("günü", "day (ACC)", .ü),
                ("yolu", "road (ACC)", .o),
                ("resmi", "picture (ACC)", .i),
            ]
            let pick = pool.randomElement()!
            let correct = "-" + pick.last.iTypeSuffix
            return DrillPrompt(
                stem: String(pick.stem.dropLast()),
                gloss: pick.gloss,
                correct: correct,
                choices: ["-ı", "-i", "-u", "-ü"],
                explanation: "Last vowel '\(pick.last.display)' is \(pick.last.harmonyGroup.displayName), so the accusative becomes \(correct).",
                drill: .iType
            )
        }
    }
}

private struct DrillResult {
    let correct: Bool
    let feedback: String
    var picked: String? = nil
}
