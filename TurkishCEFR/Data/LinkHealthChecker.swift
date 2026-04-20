import Foundation
import Combine

/// Runtime validator for the curated YouTube links shipped with each
/// lesson. At launch (and at most once per 12h per video) we ping YouTube
/// oEmbed for every `LessonResources.VideoRef`. The result is cached in
/// `UserDefaults`, so offline users still get the last-known-good status.
///
/// When a primary video fails, `preferredVideos(for:)` automatically
/// swaps in the first healthy alternate. The UI annotates a swap with a
/// subtle "link refreshed" chip so the user knows the app took care of
/// something broken.
///
/// This is intentionally HTTP-only — we never embed a YouTube iframe
/// or execute their JS. The full TLS ping costs ~70 ms per video on a
/// broadband connection, so we cap concurrency to 4 parallel requests.
@MainActor
final class LinkHealthChecker: ObservableObject {
    static let shared = LinkHealthChecker()

    struct HealthRecord: Codable, Equatable {
        let id: String
        let ok: Bool
        let checkedAt: Date
        let statusCode: Int
    }

    @Published private(set) var records: [String: HealthRecord] = [:]
    @Published private(set) var isChecking: Bool = false

    private let defaultsKey = "linkHealth.records.v1"
    private let staleSeconds: TimeInterval = 12 * 60 * 60

    private init() {
        load()
    }

    // MARK: - Public API

    /// Returns two video refs to display in the lesson UI. If a primary
    /// entry is known-dead, the next healthy alternate takes its place so
    /// the learner never sees a broken link.
    func preferredVideos(for lesson: Lesson) -> (videos: [LessonResources.VideoRef], swapped: Bool) {
        let bundle = LessonResources.bundle(for: lesson)
        var picked: [LessonResources.VideoRef] = []
        var swapped = false

        for primary in bundle.primary {
            if isHealthy(primary) {
                picked.append(primary)
                continue
            }
            // Replace with the first healthy alternate we haven't already
            // included.
            if let sub = bundle.alternates.first(where: {
                isHealthy($0) && !picked.contains($0)
            }) {
                picked.append(sub)
                swapped = true
            } else {
                picked.append(primary) // best effort — UI will grey it out
            }
        }
        return (picked, swapped)
    }

    /// A video is considered healthy if we have never checked it (give it
    /// the benefit of the doubt) or if our most recent check succeeded and
    /// is less than `staleSeconds` old.
    func isHealthy(_ ref: LessonResources.VideoRef) -> Bool {
        guard let rec = records[ref.youtubeID] else { return true }
        if Date().timeIntervalSince(rec.checkedAt) > staleSeconds {
            return true // treat stale as unknown; background refresh will settle it
        }
        return rec.ok
    }

    // MARK: - Background refresh

    /// Kick off a non-blocking background sweep of every video we know
    /// about. Respects network mode — if the user is in offline mode we
    /// bail immediately so we never surprise them with a request.
    func refresh(allowNetwork: Bool) async {
        guard allowNetwork else { return }
        guard !isChecking else { return }
        isChecking = true
        // `refresh()` is already MainActor-isolated, so clearing the flag
        // synchronously in `defer` keeps it consistent on every exit path
        // (including the early return below when nothing is stale).
        defer { isChecking = false }

        let refs = LessonResources.allReferences
        let stale = refs.filter { needsCheck($0) }
        guard !stale.isEmpty else { return }

        await withTaskGroup(of: HealthRecord?.self) { group in
            var inFlight = 0
            let maxParallel = 4
            var iter = stale.makeIterator()

            func enqueueNext() {
                guard let ref = iter.next() else { return }
                inFlight += 1
                group.addTask { await Self.probe(ref) }
            }

            for _ in 0..<min(maxParallel, stale.count) { enqueueNext() }

            for await result in group {
                inFlight -= 1
                if let rec = result {
                    await MainActor.run {
                        self.records[rec.id] = rec
                    }
                }
                enqueueNext()
            }
        }

        await MainActor.run { self.save() }
    }

    private func needsCheck(_ ref: LessonResources.VideoRef) -> Bool {
        guard let rec = records[ref.youtubeID] else { return true }
        return Date().timeIntervalSince(rec.checkedAt) > staleSeconds
    }

    private static func probe(_ ref: LessonResources.VideoRef) async -> HealthRecord? {
        var req = URLRequest(url: ref.oEmbedURL)
        req.timeoutInterval = 6
        req.setValue("TurkishCEFR/1.0", forHTTPHeaderField: "User-Agent")
        do {
            let (_, resp) = try await URLSession.shared.data(for: req)
            let code = (resp as? HTTPURLResponse)?.statusCode ?? 0
            return HealthRecord(id: ref.youtubeID,
                                ok: (200...299).contains(code),
                                checkedAt: Date(),
                                statusCode: code)
        } catch {
            return HealthRecord(id: ref.youtubeID,
                                ok: false,
                                checkedAt: Date(),
                                statusCode: -1)
        }
    }

    // MARK: - Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([String: HealthRecord].self, from: data)
        else { return }
        records = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }
}
