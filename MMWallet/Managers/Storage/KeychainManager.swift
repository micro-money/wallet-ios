//
//  KeychainManager.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 14.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import Foundation

class KeychainManager {
    
    static let shared = KeychainManager()
    
    static let sessionTokenKey = "sessionToken"
    static let pushNotificationsTokenKey = "pushNotificationsToken"
    static let usernameKey = "username"
    static let passwordKey = "password"
    static let pinKey = "pin"
    static let socialTokenKey = "socialToken"
    static let socialIdKey = "socialId"
    static let wordsKey = "words"
    
    let serviceName = Environment().configuration(PlistKey.KeychainID)
    let tag = Environment().configuration(PlistKey.KeychainID).data(using: .utf8)!
    
    private init() {}
    
    var sessionToken: String? {
        return string(forKey: KeychainManager.sessionTokenKey)
    }
    
    var pushNotificationsToken: String? {
        return string(forKey: KeychainManager.pushNotificationsTokenKey)
    }

    var username: String? {
        return string(forKey: KeychainManager.usernameKey)
    }

    var password: String? {
        return string(forKey: KeychainManager.passwordKey)
    }

    var pin: String? {
        return string(forKey: KeychainManager.pinKey)
    }

    var socialToken: String? {
        return string(forKey: KeychainManager.socialTokenKey)
    }
    var socialId: String? {
        return string(forKey: KeychainManager.socialIdKey)
    }

    var words: String? {
        return string(forKey: KeychainManager.wordsKey)
    }
    
    @discardableResult func setSessionToken(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.sessionTokenKey)
    }
    
    @discardableResult func removeSessionToken() -> Bool {
        return remove(forKey: KeychainManager.sessionTokenKey)
    }
    
    @discardableResult func setPushNotificationsToken(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.pushNotificationsTokenKey)
    }
    
    @discardableResult func removePushNotificationsToken() -> Bool {
        return remove(forKey: KeychainManager.pushNotificationsTokenKey)
    }

    @discardableResult func setUsername(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.usernameKey)
    }

    @discardableResult func removeUsername() -> Bool {
        return remove(forKey: KeychainManager.usernameKey)
    }

    @discardableResult func setPassword(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.passwordKey)
    }

    @discardableResult func removePassword() -> Bool {
        return remove(forKey: KeychainManager.passwordKey)
    }

    @discardableResult func setPin(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.pinKey)
    }

    @discardableResult func removePin() -> Bool {
        return remove(forKey: KeychainManager.pinKey)
    }

    @discardableResult func setSocialToken(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.socialTokenKey)
    }

    @discardableResult func removeSocialToken() -> Bool {
        return remove(forKey: KeychainManager.socialTokenKey)
    }

    @discardableResult func setSocialId(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.socialIdKey)
    }

    @discardableResult func removeSocialId() -> Bool {
        return remove(forKey: KeychainManager.socialIdKey)
    }

    @discardableResult func setWords(value: String) -> Bool {
        return set(value: value, forKey: KeychainManager.wordsKey)
    }

    @discardableResult func removeWords() -> Bool {
        return remove(forKey: KeychainManager.wordsKey)
    }
    
    @discardableResult func set(value: String, forKey key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            return set(value: data, forKey: key)
        } else {
            return false
        }
    }
    
    @discardableResult func set(value: Data, forKey key: String) -> Bool {
        var query = setupQuery(forKey: key)
        query[kSecValueData as String] = value
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(value: value, forKey: key)
        } else {
            return false
        }
    }
    
    @discardableResult func string(forKey key: String) -> String? {
        guard let data = data(forKey: key) else {
            return nil
        }
        return String(data: data, encoding: .utf8) as String?
    }
    
    @discardableResult func data(forKey key: String) -> Data? {
        var query = setupQuery(forKey: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status == noErr ? result as? Data : nil
    }
    
    @discardableResult func remove(forKey key: String) -> Bool {
        let query = setupQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    private func update(value: Data, forKey key: String) -> Bool {
        let query = setupQuery(forKey: key)
        let update = [kSecValueData as String : value]
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    private func setupQuery(forKey key: String) -> [String: Any] {
        let keyData = key.data(using: String.Encoding.utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: serviceName,
                                    kSecAttrGeneric as String: keyData ?? "",
                                    kSecAttrAccount as String: keyData ?? ""]
        return query
    }
    
}
