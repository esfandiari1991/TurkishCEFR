import SwiftUI
import Combine

/// Drives the first-launch guided tour. Persists "seen" + step index in
/// `UserDefaults` so a learner who quits halfway can resume exactly where
/// they left off next time they open the app.
///
/// Designed for total beginners: every step is skippable, the next button
/// is always visible, keyboard shortcuts are not required to progress.
@MainActor
final class OnboardingStore: ObservableObject {
    static let shared = OnboardingStore()

    @Published private(set) var step: Int
    @Published var isShowing: Bool

    /// When true, the shimmer highlight animates behind the current target
    /// to draw the eye. Disabled when `SettingsStore.reduceMotion` is on.
    @Published var shimmer: Bool = true

    private let defaultsFinishedKey = "onboarding.finished.v1"
    private let defaultsStepKey = "onboarding.step.v1"

    init() {
        let finished = UserDefaults.standard.bool(forKey: defaultsFinishedKey)
        let savedStep = UserDefaults.standard.integer(forKey: defaultsStepKey)
        self.step = savedStep
        self.isShowing = !finished
    }

    func advance() {
        let next = step + 1
        if next >= OnboardingStep.allCases.count {
            finish()
        } else {
            step = next
            UserDefaults.standard.set(next, forKey: defaultsStepKey)
        }
    }

    func back() {
        guard step > 0 else { return }
        step -= 1
        UserDefaults.standard.set(step, forKey: defaultsStepKey)
    }

    func skip() { finish() }

    func restart() {
        step = 0
        UserDefaults.standard.set(0, forKey: defaultsStepKey)
        UserDefaults.standard.set(false, forKey: defaultsFinishedKey)
        isShowing = true
    }

    private func finish() {
        isShowing = false
        UserDefaults.standard.set(true, forKey: defaultsFinishedKey)
    }

    var currentStep: OnboardingStep {
        OnboardingStep.allCases[min(step, OnboardingStep.allCases.count - 1)]
    }
}
