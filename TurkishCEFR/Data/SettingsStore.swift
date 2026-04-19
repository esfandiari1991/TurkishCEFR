import SwiftUI

/// User-tunable display / behaviour settings. Backed by UserDefaults via
/// @AppStorage so preferences persist instantly across launches.
final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    // Font scale is multiplied into dynamic type across the app.
    @AppStorage("fontScale") var fontScale: Double = 1.0
    @AppStorage("preferredAppearance") var appearance: String = "system"
    @AppStorage("speechRate") var speechRate: Double = 0.48
    @AppStorage(Speech.voiceDefaultsKey) var voiceIdentifier: String = ""
    @AppStorage("confettiEnabled") var confettiEnabled: Bool = true
    @AppStorage("reduceMotion") var reduceMotion: Bool = false

    var colorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil
        }
    }
}
