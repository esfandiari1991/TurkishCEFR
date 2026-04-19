import SwiftUI
import AVFoundation

struct SettingsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage("speechRate") private var speechRate: Double = 0.48
    @AppStorage("preferredAppearance") private var appearance: String = "system"
    @AppStorage(Speech.voiceDefaultsKey) private var voiceIdentifier: String = ""

    @State private var voices: [AVSpeechSynthesisVoice] = []

    var body: some View {
        TabView {
            generalTab.tabItem { Label("General", systemImage: "gear") }
            voiceTab.tabItem   { Label("Voice", systemImage: "waveform") }
            badgesTab.tabItem  { Label("Badges", systemImage: "rosette") }
            dataTab.tabItem    { Label("Data", systemImage: "tray.full") }
        }
        .frame(width: 640, height: 440)
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
            }
            Section("Pronunciation") {
                HStack {
                    Text("Speech rate")
                    Slider(value: $speechRate, in: 0.3...0.7)
                    Text(String(format: "%.2f", speechRate))
                        .monospacedDigit()
                        .frame(width: 48)
                }
                Button("Test voice") {
                    Speech.shared.speak("Merhaba, ben İstanbul'dan konuşuyorum.", rate: Float(speechRate))
                }
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
            Section("Data") {
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
                Button(role: .destructive) {
                    progress.resetEverything()
                } label: {
                    Label("Reset All Progress, XP, Streak and Badges",
                          systemImage: "arrow.counterclockwise")
                }
            }
        }
        .padding(20)
    }
}
