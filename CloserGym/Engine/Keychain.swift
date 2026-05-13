import Foundation
import Security

/// Minimal Keychain wrapper for storing the optional Anthropic API key.
/// Sandboxed to this app's bundle, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly.
public enum Keychain {
    private static let service = "com.melmarion.CloserGym"
    private static let apiKeyAccount = "anthropic-api-key"

    public static func saveAPIKey(_ key: String) {
        guard let data = key.data(using: .utf8) else { return }
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
        SecItemAdd(add as CFDictionary, nil)
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
