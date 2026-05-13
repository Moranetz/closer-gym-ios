import SwiftUI

struct RootTabView: View {
    @State private var selected: Tab = .puzzles

    enum Tab: Hashable {
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
