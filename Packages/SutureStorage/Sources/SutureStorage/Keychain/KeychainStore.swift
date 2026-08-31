import Foundation
import Security
import SutureCore

/// Actor providing thread-safe, encrypted credential storage with iCloud Keychain synchronization.
public actor KeychainStore {
    public static let shared = KeychainStore()
    
    private let service: String
    private let accessGroup: String?
    
    public init(service: String = "com.suture.app.credentials", accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    /// Saves a sensitive string (token, API key) to the synchronized iCloud Keychain.
    public func set(_ value: String, for account: String, synchronizeWithiCloud: Bool = true) throws {
        guard let data = value.data(using: .utf8) else { return }
        
        // Remove existing item before inserting
        try delete(for: account)
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        if synchronizeWithiCloud {
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            SutureLogger.storage.error("Keychain insert failed for \(account): \(status)")
            throw SutureError.unknown(message: "Keychain insert error: \(status)")
        }
    }
    
    /// Retrieves a sensitive string for the specified account.
    public func get(for account: String) -> String? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data, let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
    
    /// Deletes a key from the Keychain.
    public func delete(for account: String) throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            SutureLogger.storage.error("Keychain delete failed for \(account): \(status)")
        }
    }
}
