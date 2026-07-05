import SwiftUI

@main
struct FrameForkApp: App {
    @StateObject private var storage = Store.shared
    @StateObject private var subscriptions = SubscriptionStore()   // starts the StoreKit listener at launch
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "framefork:hasSeenOnboarding:v1")

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(storage)
                .environmentObject(subscriptions)
                .preferredColorScheme(.dark)
                .tint(.brandGreen)
                .background(Color.bgPage.ignoresSafeArea())
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView(isPresented: $showOnboarding)
                        .environmentObject(storage)
                }
                .task {
                    // Reconcile a permission revoked in iOS Settings at LAUNCH — the
                    // Settings screen does the same, but a user who never opens it
                    // would otherwise keep an armed-looking reminder that never fires.
                    if DailyNotifications.isEnabled, await DailyNotifications.status() == .denied {
                        DailyNotifications.isEnabled = false
                        DailyNotifications.cancel()
                    }
                }
        }
    }
}
