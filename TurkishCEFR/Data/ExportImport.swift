import Foundation
import AppKit
import UniformTypeIdentifiers

/// JSON-based export / import for the user's progress, stats, and badges.
/// The snapshot is schema-versioned so we can evolve the format safely.
enum ExportImport {
    static let currentVersion = 1

    struct Payload: Codable {
        var version: Int
        var exportedAt: Date
        var app: String
        var lessonProgress: [String: LessonProgress]
        var stats: PlayerStats
    }

    @MainActor
    static func exportToFile(progress: ProgressStore) {
        let payload = Payload(
            version: currentVersion,
            exportedAt: .init(),
            app: "TurkishCEFR",
            lessonProgress: progress.lessonProgress,
            stats: progress.stats
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(payload) else { return }

        let panel = NSSavePanel()
        panel.nameFieldStringValue = "turkishcefr-progress.json"
        panel.allowedContentTypes = [.json]
        panel.prompt = "Export"
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? data.write(to: url)
            }
        }
    }

    @MainActor
    static func importFromFile(progress: ProgressStore) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.prompt = "Import"
        panel.begin { response in
            guard response == .OK, let url = panel.url,
                  let data = try? Data(contentsOf: url) else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let payload = try? decoder.decode(Payload.self, from: data) else {
                presentAlert(title: "Import failed",
                             message: "The selected file is not a valid TurkishCEFR progress export.")
                return
            }
            Task { @MainActor in
                progress.applyImported(lessonProgress: payload.lessonProgress,
                                       stats: payload.stats)
                presentAlert(title: "Import complete",
                             message: "Progress restored from \(url.lastPathComponent).")
            }
        }
    }

    @MainActor
    private static func presentAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
