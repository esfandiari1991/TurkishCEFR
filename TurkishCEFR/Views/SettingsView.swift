import SwiftUI
import AVFoundation

struct SettingsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage("speechRate") private var speechRate: Double = 0.48
    @AppStorage("preferredAppearance") private var appearance: String = "system"
    @AppStorage(Speech.voiceDefaultsKey) private var voiceIdentifier: String = ""
    @AppStorage("fontScale") private var fontScale: Double = 1.0
    @AppStorage("confettiEnabled") private var confettiEnabled: Bool = true
    @AppStorage("reduceMotion") private var reduceMotion: Bool = false

    @State private var voices: [AVSpeechSynthesisVoice] = []
    @State private var confirmingReset: Bool = false

    var body: some View {
        TabView {
            generalTab.tabItem { Label("General", systemImage: "gear") }
            voiceTab.tabItem   { Label("Voice", systemImage: "waveform") }
            badgesTab.tabItem  { Label("Badges", systemImage: "rosette") }
            dataTab.tabItem    { Label("Data", systemImage: "tray.full") }
        }
        .frame(width: 680, height: 520)
        .onAppear(perform: refreshVoices)
        .onChange(of: speechRate) { _, new in
            UserDefaults.standard.set(new, forKey: Speech.rateDefaultsKey)
        }
    }

    // MARK: General

    private var generalTab: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: $appearance) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Font size")
                    Slider(value: $fontScale, in: 0.85...1.3, step: 0.05)
                    Text(String(format: "%.0f%%", fontScale * 100))
                        .monospacedDigit()
                        .frame(width: 56)
                }

                Toggle(isOn: $confettiEnabled) {
                    Label("Celebrate level ups with confetti", systemImage: "sparkles")
                }
                Toggle(isOn: $reduceMotion) {
                    Label("Reduce motion (gentler animations)", systemImage: "wind")
                }
            }
            Section("Pronunciation") {
                HStack {
                    Text("Speech rate")
                    Slider(value: $speechRate, in: 0.3...0.7)
                    Text(String(format: "%.2fx", speechRate / 0.5))
                        .monospacedDigit()
                        .frame(width: 56)
                }
                Button("Test voice") {
                    Speech.shared.speak("Merhaba, ben İstanbul'dan konuşuyorum.", rate: Float(speechRate))
                }
            }
            Section("Preview") {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Kitap").font(.system(size: 18 * fontScale, weight: .semibold))
                        Text("book — a collection of written pages.")
                            .font(.system(size: 13 * fontScale))
                            .foregroundStyle(.secondary)
                        Text("“Yeni bir kitap alıyorum.” — I'm buying a new book.")
                            .font(.system(size: 11 * fontScale))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(12)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(20)
    }

    // MARK: Voice

    private var voiceTab: some View {
        Form {
            Section("Turkish voice · Türkçe ses") {
                if voices.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("No Turkish voices installed on this Mac.",
                              systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text("Open System Settings → Accessibility → Spoken Content → System Voice → Manage Voices → Turkish, and download “Yelda (Enhanced)” for an Istanbul accent.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Button {
                            Speech.openVoiceDownloadSettings()
                        } label: {
                            Label("Open Voice Settings", systemImage: "arrow.up.forward.app.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Picker("Voice", selection: $voiceIdentifier) {
                        Text("Auto (best available)").tag("")
                        Divider()
                        ForEach(voices, id: \.identifier) { v in
                            Text(label(for: v)).tag(v.identifier)
                        }
                    }
                    .pickerStyle(.menu)

                    HStack {
                        Button("Test voice") {
                            Speech.shared.speak("Merhaba, benim adım Yelda. İstanbul'dan sevgiler!",
                                                 rate: Float(speechRate))
                        }
                        Spacer()
                        Button {
                            Speech.openVoiceDownloadSettings()
                        } label: {
                            Label("Download more voices", systemImage: "square.and.arrow.down")
                        }
                    }

                    if !Speech.shared.hasPremiumTurkishVoice {
                        Label("Tip: download the Enhanced/Premium Yelda voice for a crisp Istanbul accent.",
                              systemImage: "lightbulb.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }
            Section("Test phrases") {
                ForEach([
                    "Merhaba! Nasılsınız?",
                    "İstanbul Boğazı çok güzel.",
                    "Türkçe öğrenmek keyifli."
                ], id: \.self) { phrase in
                    HStack {
                        Text(phrase).font(.callout)
                        Spacer()
                        Button {
                            Speech.shared.speak(phrase, rate: Float(speechRate))
                        } label: {
                            Image(systemName: "play.circle.fill")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(20)
    }

    private func label(for v: AVSpeechSynthesisVoice) -> String {
        let loc = Locale(identifier: v.language).localizedString(forLanguageCode: v.language) ?? v.language
        return "\(v.name) · \(loc) · \(v.quality.label)"
    }

    private func refreshVoices() {
        voices = Speech.shared.availableTurkishVoices
    }

    // MARK: Badges

    private var badgesTab: some View {
        VStack(spacing: 0) {
            HStack {
                Label("\(progress.stats.unlockedBadges.count) of \(BadgeCatalog.all.count) earned",
                      systemImage: "rosette")
                    .font(.headline)
                Spacer()
                Text("Level \(progress.stats.level) · \(progress.stats.totalXP) XP")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20).padding(.top, 12)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 170, maximum: 220), spacing: 12)],
                          spacing: 12) {
                    ForEach(BadgeCatalog.all) { badge in
                        BadgeTile(badge: badge,
                                  unlocked: progress.stats.unlockedBadges.contains(badge.id))
                    }
                }
                .padding(16)
            }
        }
    }

    // MARK: Data

    private var dataTab: some View {
        Form {
            Section("Snapshot") {
                HStack {
                    Label("Streak", systemImage: "flame.fill").foregroundStyle(.orange)
                    Spacer()
                    Text("\(progress.stats.streakDays) days · longest \(progress.stats.longestStreak)")
                        .font(.callout.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Label("Total XP", systemImage: "bolt.fill").foregroundStyle(.yellow)
                    Spacer()
                    Text("\(progress.stats.totalXP)")
                        .font(.callout.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Label("Lessons completed", systemImage: "book.closed.fill")
                    Spacer()
                    Text("\(progress.stats.lessonsCompleted)")
                        .font(.callout.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Label("Accuracy", systemImage: "target")
                    Spacer()
                    Text("\(progress.stats.accuracyPercent)%  ·  \(progress.stats.exercisePerfectCount)/\(progress.stats.exerciseAttempts)")
                        .font(.callout.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Label("Study time", systemImage: "clock.fill")
                    Spacer()
                    Text(progress.stats.humanStudyTime)
                        .font(.callout.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }

            Section("Export / Import") {
                HStack(spacing: 12) {
                    Button {
                        ExportImport.exportToFile(progress: progress)
                    } label: {
                        Label("Export progress…", systemImage: "square.and.arrow.up")
                    }
                    Button {
                        ExportImport.importFromFile(progress: progress)
                    } label: {
                        Label("Import progress…", systemImage: "square.and.arrow.down")
                    }
                }
                Text("Back up your XP, streak, badges, and lesson completion to a JSON file, or restore from one.")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("Danger zone") {
                Button(role: .destructive) {
                    confirmingReset = true
                } label: {
                    Label("Reset all progress, XP, streak and badges",
                          systemImage: "arrow.counterclockwise")
                }
                .alert("Reset everything?", isPresented: $confirmingReset) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        progress.resetEverything()
                    }
                } message: {
                    Text("This will clear your XP, level, daily streak, badges, and every lesson's completion status. This action cannot be undone.")
                }
            }
        }
        .padding(20)
    }
}
