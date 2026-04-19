import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var curriculum: CurriculumStore
    @EnvironmentObject private var progress: ProgressStore

    @State private var selectedLevel: CEFRLevel? = .a1
    @State private var selectedLesson: Lesson?

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
        .onChange(of: selectedLevel) { _, _ in
            // Clear lesson selection when the user switches level.
            selectedLesson = nil
        }
        .onReceive(NotificationCenter.default.publisher(for: .resetLevelProgress)) { _ in
            if let level = selectedLevel {
                progress.resetLevel(level, lessons: curriculum.lessons(for: level))
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
