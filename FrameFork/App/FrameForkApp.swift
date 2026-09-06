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

/// Launch hooks that exist only so a headless script can photograph a screen the simulator
/// cannot tap its way to. Every read goes through here, and here reads a variable only in a
/// DEBUG build.
///
/// Fleet round 131 found six of these being read directly in shipping code, and proved the
/// consequence rather than assuming it: a Release build of Frame & Fork, launched with
/// `FF_INITIAL_TAB=play FF_PUSH_SPARRING=1`, opened a live sparring session against the first
/// bot on the ladder before the player had touched anything. A comment above one of them read
/// "No effect on shipping behavior; the launcher only sets it from sim builds", which was a
/// claim about who sets the variable and not about what the binary does when someone else does.
enum CaptureHooks {
    static func value(_ name: String) -> String? {
        #if DEBUG
        return ProcessInfo.processInfo.environment[name]
        #else
        return nil
        #endif
    }

    static func isOn(_ name: String) -> Bool { value(name) == "1" }
}
