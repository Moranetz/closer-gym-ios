import Foundation

public enum FeatureFlags {
    /// Native subscriptions (StoreKit) are fully built but kept OFF until the server proxy and
    /// the App Store Connect products exist. Reasons (see SECURITY.md + BACKEND-HANDOFF.md):
    ///   1. A subscription has nothing to unlock yet — the LLM still runs on the user's own key
    ///      (BYO-key). Selling a sub that does nothing is a UX failure and an App Store risk.
    ///   2. A client-only entitlement is not a security boundary (T4). It must be verified
    ///      server-to-Apple before it gates anything that costs the owner money.
    /// Flip to `true` ONLY when: the proxy serves the LLM on the owner's key AND the server
    /// verifies the StoreKit entitlement AND the auto-renewable products are live in ASC.
    public static let subscriptionsEnabled = false
}
