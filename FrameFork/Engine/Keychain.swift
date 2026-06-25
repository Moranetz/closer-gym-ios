import Foundation
import Security

/// Minimal Keychain wrapper for storing the optional Anthropic API key.
/// Sandboxed to this app's bundle, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly.
public enum Keychain {
    private static let service = "com.melmarion.FrameFork"
    private static let apiKeyAccount = "anthropic-api-key"

    /// Returns true on success so callers can surface a real failure (e.g. device
    /// locked, missing entitlement) instead of silently believing the key was saved.
    @discardableResult
    public static func saveAPIKey(_ key: String) -> Bool {
        guard let data = key.data(using: .utf8) else { return false }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
        ]
        // Delete any existing item first so SecItemAdd never fails on duplicate.
        SecItemDelete(query as CFDictionary)
        var add = query
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        return SecItemAdd(add as CFDictionary, nil) == errSecSuccess
    }

    public static func loadAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data, let key = String(data: data, encoding: .utf8) else {
            return nil
        }
        return key
    }

    public static func deleteAPIKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
        ]
        SecItemDelete(query as CFDictionary)
    }

    public static func hasAPIKey() -> Bool {
        loadAPIKey()?.isEmpty == false
    }
}
