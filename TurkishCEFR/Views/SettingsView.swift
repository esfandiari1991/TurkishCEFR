import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage("speechRate") private var speechRate: Double = 0.48
    @AppStorage("preferredAppearance") private var appearance: String = "system"

    var body: some View {
        TabView {
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
                        Speech.shared.speak("Merhaba, Türkçe öğreniyorum.", rate: Float(speechRate))
                    }
                }
            }
            .padding(20)
            .tabItem { Label("General", systemImage: "gear") }

            Form {
                Section("Data") {
                    Button(role: .destructive) {
                        progress.lessonProgress.removeAll()
                    } label: {
                        Label("Reset All Progress", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .padding(20)
            .tabItem { Label("Progress", systemImage: "chart.bar") }
        }
        .frame(width: 520, height: 320)
    }
}
