import SwiftUI

@main
struct CloserGymApp: App {
    @StateObject private var storage = Store.shared
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "closer-gym:hasSeenOnboarding:v1")

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(storage)
                .preferredColorScheme(.dark)
                .tint(.brandGreen)
                .background(Color.bgPage.ignoresSafeArea())
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView(isPresented: $showOnboarding)
                        .environmentObject(storage)
                }
        }
    }
}
