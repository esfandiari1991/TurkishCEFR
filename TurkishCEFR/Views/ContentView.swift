import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage("confettiEnabled") private var confettiEnabled: Bool = true
    @AppStorage("fontScale") private var fontScale: Double = 1.0

    @State private var selectedLevel: CEFRLevel? = .a1
    @State private var selectedLesson: Lesson?
    @State private var showBadges: Bool = false
    @State private var showSearch: Bool = false
    @State private var showStats: Bool = false
    @State private var showDictionary: Bool = false
    @State private var showConjugator: Bool = false
    @State private var showReview: Bool = false
    @State private var showDialogues: Bool = false
    @State private var showDailyChallenge: Bool = false
    @State private var confettiTrigger: Bool = false
    @State private var visibleLevelUp: ProgressStore.LevelUpEvent?
    @State private var visibleXPChip: ProgressStore.XPAwardEvent?
    @State private var visibleBadgeToast: Badge?

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedLevel)
                .navigationSplitViewColumnWidth(min: 220, ideal: 240, max: 280)
        } content: {
            if let level = selectedLevel {
                LessonListView(level: level, selection: $selectedLesson)
                    .navigationSplitViewColumnWidth(min: 300, ideal: 340, max: 420)
                    .id(level)
            } else {
                EmptyMiddleColumn()
            }
        } detail: {
            Group {
                if let lesson = selectedLesson {
                    LessonDetailView(lesson: lesson)
                        .id(lesson.id)
                } else if let level = selectedLevel {
                    LevelOverviewView(level: level, selectedLesson: $selectedLesson)
                        .id(level)
                } else {
                    WelcomeView()
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack(spacing: 10) {
                Button { showSearch = true } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Search lessons (⌘F)")
                .keyboardShortcut("f", modifiers: .command)

                Button { showDictionary = true } label: {
                    Label("Dictionary", systemImage: "character.book.closed.fill")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Offline dictionary (⌘K)")
                .keyboardShortcut("k", modifiers: .command)

                Button { showConjugator = true } label: {
                    Label("Conjugator", systemImage: "wand.and.stars")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Turkish verb conjugator (⌘J)")
                .keyboardShortcut("j", modifiers: .command)

                Spacer()
                XPHUD(showBadgesSheet: $showBadges)
                Spacer()

                Button { showDailyChallenge = true } label: {
                    Label("Daily Challenge", systemImage: "flame.fill")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Daily challenge (⌘T)")
                .keyboardShortcut("t", modifiers: .command)

                Button { showReview = true } label: {
                    Label("Review", systemImage: "brain.head.profile")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Spaced-repetition review (⌘R)")
                .keyboardShortcut("r", modifiers: .command)

                Button { showDialogues = true } label: {
                    Label("Phrasebook", systemImage: "bubble.left.and.bubble.right.fill")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Situational dialogues (⌘P)")
                .keyboardShortcut("p", modifiers: .command)

                Button { showStats = true } label: {
                    Label("Stats", systemImage: "chart.bar.xaxis.ascending")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .help("Open stats dashboard (⌘D)")
                .keyboardShortcut("d", modifiers: .command)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .overlay(alignment: .top) { toastStack.padding(.top, 68) }
        .overlay {
            if confettiEnabled {
                ConfettiView(isActive: confettiTrigger)
                    .allowsHitTesting(false)
            }
        }
        .environment(\.sizeCategory, sizeCategory(for: fontScale))
        .sheet(isPresented: $showBadges) { BadgeWall() }
        .sheet(isPresented: $showSearch) {
            LessonSearchView(selectedLevel: $selectedLevel,
                             selectedLesson: $selectedLesson)
        }
        .sheet(isPresented: $showStats) { StatsDashboardView() }
        .sheet(isPresented: $showDictionary) { DictionaryView() }
        .sheet(isPresented: $showConjugator) { ConjugatorView() }
        .sheet(isPresented: $showReview) { ReviewView() }
        .sheet(isPresented: $showDialogues) { DialoguesView() }
        .sheet(isPresented: $showDailyChallenge) { DailyChallengeView() }
        .onChange(of: selectedLevel) { _, _ in
            selectedLesson = nil
        }
        .onReceive(NotificationCenter.default.publisher(for: .resetLevelProgress)) { _ in
            if let level = selectedLevel {
                progress.resetLevel(level, lessons: curriculum.lessons(for: level))
            }
        }
        .onChange(of: progress.levelUpEvent) { _, newEvent in
            guard let event = newEvent else { return }
            visibleLevelUp = event
            if confettiEnabled {
                confettiTrigger.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation { visibleLevelUp = nil }
            }
        }
        .onChange(of: progress.lastXPAward) { _, newEvent in
            guard let event = newEvent else { return }
            visibleXPChip = event
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation { visibleXPChip = nil }
            }
        }
        .onChange(of: progress.stats.pendingBadgeToasts) { _, _ in
            popNextBadgeIfNeeded()
        }
        .onAppear {
            _ = progress.checkBadges(allLessons: curriculum.allLessons)
            popNextBadgeIfNeeded()
        }
    }

    private func sizeCategory(for scale: Double) -> ContentSizeCategory {
        switch scale {
        case ..<0.9:   return .small
        case ..<0.95:  return .medium
        case ..<1.05:  return .large
        case ..<1.15:  return .extraLarge
        case ..<1.25:  return .extraExtraLarge
        default:       return .extraExtraExtraLarge
        }
    }

    private func popNextBadgeIfNeeded() {
        guard visibleBadgeToast == nil else { return }
        if let next = progress.consumeBadgeToast() {
            visibleBadgeToast = next
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation { visibleBadgeToast = nil }
                popNextBadgeIfNeeded()
            }
        }
    }

    @ViewBuilder
    private var toastStack: some View {
        VStack(spacing: 10) {
            if let lv = visibleLevelUp {
                LevelUpToast(event: lv)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            if let xp = visibleXPChip {
                XPChip(event: xp)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            if let badge = visibleBadgeToast {
                BadgeToast(badge: badge)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.pages.fill")
                .font(.system(size: 72))
                .foregroundStyle(.linearGradient(
                    colors: [.red, .orange],
                    startPoint: .top, endPoint: .bottom
                ))
            Text("Türkçe'ye Hoş Geldiniz")
                .font(.system(size: 34, weight: .semibold, design: .serif))
            Text("Welcome to Turkish — choose a CEFR level from the sidebar to begin.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 520)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
        .background(GradientBackground())
    }
}

struct EmptyMiddleColumn: View {
    var body: some View {
        ContentUnavailableView(
            "Pick a level",
            systemImage: "sidebar.left",
            description: Text("Select a CEFR level on the left to see its lessons.")
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(CurriculumStore())
        .environmentObject(ProgressStore())
        .frame(width: 1200, height: 800)
}
