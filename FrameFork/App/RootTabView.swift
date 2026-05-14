import SwiftUI

struct RootTabView: View {
    // The `FF_INITIAL_TAB` env var lets `scripts/upload_ipad_screenshots.py`
    // launch into a specific tab when generating store-listing screenshots.
    // No effect on shipping behavior; the launcher only sets it from sim builds.
    @State private var selected: Tab = {
        if let raw = ProcessInfo.processInfo.environment["FF_INITIAL_TAB"],
           let tab = Tab(rawValue: raw) {
            return tab
        }
        return .puzzles
    }()

    enum Tab: String, Hashable {
        case play, puzzles, lessons, watch, profile
    }

    var body: some View {
        TabView(selection: $selected) {
            PlayTab()
                .tabItem {
                    Label("Play", systemImage: "gamecontroller.fill")
                }
                .tag(Tab.play)

            PuzzlesTab()
                .tabItem {
                    Label("Puzzles", systemImage: "puzzlepiece.extension.fill")
                }
                .tag(Tab.puzzles)

            LessonsTab()
                .tabItem {
                    Label("Lessons", systemImage: "graduationcap.fill")
                }
                .tag(Tab.lessons)

            WatchTab()
                .tabItem {
                    Label("Watch", systemImage: "play.rectangle.fill")
                }
                .tag(Tab.watch)

            ProfileTab()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(Tab.profile)
        }
        .onChange(of: selected) { _, _ in
            Haptics.shared.selection()
        }
        .background(Color.bgPage.ignoresSafeArea())
    }
}
