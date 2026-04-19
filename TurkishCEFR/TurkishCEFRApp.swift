import SwiftUI
import AppKit

@main
struct TurkishCEFRApp: App {
    @StateObject private var curriculum = CurriculumStore()
    @StateObject private var progress = ProgressStore()
    @AppStorage("preferredAppearance") private var preferredAppearance: String = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(curriculum)
                .environmentObject(progress)
                .frame(minWidth: 1100, minHeight: 720)
                .preferredColorScheme(colorScheme)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About TurkishCEFR") {
                    NSApp.orderFrontStandardAboutPanel(nil)
                }
            }
            CommandMenu("Study") {
                Button("Reset Progress for Current Level") {
                    NotificationCenter.default.post(name: .resetLevelProgress, object: nil)
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
            }
        }

        Settings {
            SettingsView()
                .environmentObject(progress)
        }
    }

    private var colorScheme: ColorScheme? {
        switch preferredAppearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}

extension Notification.Name {
    static let resetLevelProgress = Notification.Name("resetLevelProgress")
}
