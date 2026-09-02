import Foundation

/// App Store Guideline 5.1.2(i): the user must explicitly consent, in-app, before any of their
/// typed lines, the game transcript, or their Company Profile leave the device for Anthropic.
/// One flag, persisted in UserDefaults. Gate every `AnthropicClient` call site on `granted`.
public enum AIConsent {
    private static let key = "framefork:aiConsent:v1"

    public static var granted: Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    public static func grant() {
        UserDefaults.standard.set(true, forKey: key)
    }

    public static func revoke() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
