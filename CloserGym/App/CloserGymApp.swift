import SwiftUI

@main
struct CloserGymApp: App {
    @StateObject private var storage = Store.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(storage)
                .preferredColorScheme(.dark)
                .tint(.brandGreen)
                .background(Color.bgPage.ignoresSafeArea())
        }
    }
}
