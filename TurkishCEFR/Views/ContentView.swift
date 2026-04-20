import SwiftUI

/// Root navigation scaffold.
///
/// * A three-column `NavigationSplitView` (sidebar → lessons-or-tool → detail)
///   wraps everything.
/// * `AppSection` drives the sidebar so the same switch handles levels,
///   tools, progress tabs and podcasts — no more scattered sheet booleans
///   drifting out of sync.
/// * The XP HUD is collapsible / dismissible / draggable (see XPHUD.swift);
///   its buttons deep-link into Stats and Badges.
/// * `ConnectionBanner` shows the friendly "Bağlanıyor → Bağlandı" message
///   while `CorpusStore` warms up in the background.
/// * `SpeechStopHUD` is an always-pinned Stop button that appears whenever
///   the speech synthesizer is active (fixes the "Play All has no stop"
///   complaint).
struct ContentView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore
    @AppStorage("confettiEnabled") private var confettiEnabled: Bool = true
    @AppStorage("fontScale") private var fontScale: Double = 1.0

    @State private var selection: AppSection? = .welcome
    @State private var selectedLesson: Lesson?
    @State private var showBadges: Bool = false
    @State private var showSearch: Bool = false
    @State private var showStats: Bool = false
    @State private var confettiTrigger: Bool = false
    @State private var visibleLevelUp: ProgressStore.LevelUpEvent?
    @State private var visibleXPChip: ProgressStore.XPAwardEvent?
    @State private var visibleBadgeToast: Badge?

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        } content: {
            middleColumn
                .navigationSplitViewColumnWidth(min: 300, ideal: 360, max: 440)
        } detail: {
            detailColumn
        }
        .navigationSplitViewStyle(.balanced)
        .safeAreaInset(edge: .top, spacing: 0) {
            topBar
        }
        .overlay(alignment: .top) {
            VStack(spacing: Spacing.xs) {
                ConnectionBanner()
                toastStack
            }
            .padding(.top, 74)
        }
        .overlay(alignment: .bottom) {
            SpeechStopHUD().padding(Spacing.md)
        }
        .overlay {
            if confettiEnabled {
                ConfettiView(isActive: confettiTrigger)
                    .allowsHitTesting(false)
            }
        }
        .environment(\.sizeCategory, sizeCategory(for: fontScale))
        .sheet(isPresented: $showBadges) { BadgeWall() }
        .sheet(isPresented: $showSearch) {
            // Lesson search uses the old level/lesson binding model, so we
            // adapt it here on the fly.
            LessonSearchView(selectedLevel: levelBinding,
                             selectedLesson: $selectedLesson)
        }
        .sheet(isPresented: $showStats) { StatsDashboardView() }
        .onChange(of: selection) { _, _ in
            // Clearing the lesson when the primary section changes keeps the
            // detail pane from showing a stale lesson for a different level.
            selectedLesson = nil
        }
        .onChange(of: progress.levelUpEvent) { _, newEvent in
            guard let event = newEvent else { return }
            visibleLevelUp = event
            if confettiEnabled { confettiTrigger.toggle() }
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
        .task {
            await warmUpStores()
        }
        .onAppear {
            _ = progress.checkBadges(allLessons: curriculum.allLessons)
            popNextBadgeIfNeeded()
        }
    }

    // MARK: - Top bar (search + HUD)

    private var topBar: some View {
        HStack(spacing: Spacing.sm) {
            Button { showSearch = true } label: {
                Label("Search", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
                    .font(.system(size: IconSize.body))
            }
            .buttonStyle(.borderless)
            .help("Search lessons (⌘F)")
            .keyboardShortcut("f", modifiers: .command)

            NetworkModeBadge()

            Spacer()

            XPHUD(showBadgesSheet: $showBadges,
                  openStats: { showStats = true },
                  openStreak: { showStats = true })

            Spacer()

            Button { showStats = true } label: {
                Label("Stats", systemImage: "chart.bar.xaxis.ascending")
                    .labelStyle(.iconOnly)
                    .font(.system(size: IconSize.body))
            }
            .buttonStyle(.borderless)
            .help("Open stats dashboard (⌘D)")
            .keyboardShortcut("d", modifiers: .command)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, Spacing.xs)
        .padding(.bottom, Spacing.xxs)
    }

    // MARK: - Middle column

    @ViewBuilder
    private var middleColumn: some View {
        switch selection {
        case .level(let level):
            LessonListView(level: level, selection: $selectedLesson).id(level)
        case .lesson(let id):
            if let l = curriculum.lesson(id: id) {
                LessonListView(level: l.level, selection: $selectedLesson).id(l.level)
            } else {
                EmptyMiddleColumn()
            }
        default:
            EmptyMiddleColumn()
        }
    }

    // MARK: - Detail column

    @ViewBuilder
    private var detailColumn: some View {
        switch selection {
        case .none, .some(.welcome):
            WelcomeView()
        case .level(let level):
            if let lesson = selectedLesson {
                LessonDetailView(lesson: lesson).id(lesson.id)
            } else {
                LevelOverviewView(level: level, selectedLesson: $selectedLesson).id(level)
            }
        case .lesson(let id):
            if let lesson = curriculum.lesson(id: id) {
                LessonDetailView(lesson: lesson).id(lesson.id)
            } else {
                WelcomeView()
            }
        case .tool(let tool):
            switch tool {
            case .dictionary: DictionaryView()
            case .conjugator: ConjugatorView()
            case .review:     ReviewView()
            case .daily:      DailyChallengeView()
            case .phrasebook: DialoguesView()
            }
        case .podcasts:
            PodcastsView()
        case .progress(let tab):
            switch tab {
            case .stats:   StatsDashboardView()
            case .heatmap: HeatmapPane()
            case .badges:  BadgeWall()
            }
        }
    }

    // MARK: - Helpers

    private var levelBinding: Binding<CEFRLevel?> {
        Binding(
            get: {
                if case .level(let lvl) = selection { return lvl }
                return nil
            },
            set: { newValue in
                if let v = newValue { selection = .level(v) }
            }
        )
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

    /// Warms up the heavy stores on a background task so the first paint of
    /// the UI is instant. Shows the user a professional banner when the
    /// corpus is ready.
    private func warmUpStores() async {
        await MainActor.run {
            ConnectionCenter.shared.beginLoading("Unpacking corpus + dictionary…")
        }
        // Allow the first paint to settle before we touch the corpus, which
        // keeps launch feeling instant even on older Intel Macs.
        try? await Task.sleep(nanoseconds: 180_000_000)
        let pairs = await MainActor.run { CorpusStore.shared.pairs.count }
        let words = await MainActor.run { CorpusStore.shared.frequency.count }
        await MainActor.run {
            ConnectionCenter.shared.finishLoading(
                summary: "\(pairs.formatted()) sentences · \(words.formatted()) words · fully offline"
            )
        }
    }
}

// MARK: - Small adapters

private struct NetworkModeBadge: View {
    @ObservedObject private var network = NetworkModeStore.shared
    var body: some View {
        Button {
            network.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: network.mode.systemImage)
                Text(network.mode.title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, 4)
            .background(Capsule().fill(network.mode.tint.opacity(0.85)))
        }
        .buttonStyle(.plain)
        .help(network.mode.description)
    }
}

/// Wrap HeatmapView in a titled pane so it renders nicely as a detail column.
private struct HeatmapPane: View {
    @EnvironmentObject private var progress: ProgressStore
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Activity · Heatmap")
                .displayTitle()
            Text("Each cell represents one day. Darker squares = more study sessions. Hover a cell to see the date.")
                .font(DisplayFont.body)
                .foregroundStyle(.secondary)
                .lineSpacing(LineHeight.body)
            HeatmapView(weeks: 18,
                        dailyActivity: progress.stats.dailyActivity,
                        tint: BrandTheme.turquoise)
                .frame(minHeight: 220)
            Spacer()
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "book.pages.fill")
                .font(.system(size: IconSize.displayHero))
                .foregroundStyle(.linearGradient(
                    colors: [BrandTheme.crimson, BrandTheme.gold],
                    startPoint: .top, endPoint: .bottom
                ))
            Text("Türkçe'ye Hoş Geldiniz")
                .turkishDisplayTitle()
            Text("Welcome to Turkish. Choose a CEFR level from the sidebar to begin — or jump into Daily Challenge, the Dictionary, or one of the 20+ curated podcasts.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(LineHeight.body)
                .frame(maxWidth: 620)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
        .background(GradientBackground())
    }
}

struct EmptyMiddleColumn: View {
    var body: some View {
        ContentUnavailableView(
            "Pick a level or a tool",
            systemImage: "sidebar.left",
            description: Text("Select a CEFR level, a Toolkit entry, or a Progress tab from the sidebar on the left.")
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(CurriculumStore())
        .environmentObject(ProgressStore())
        .frame(width: 1280, height: 820)
}
