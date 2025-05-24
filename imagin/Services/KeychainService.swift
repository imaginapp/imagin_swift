//
//  KeychainService.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//


import Foundation
import Security

enum KeyChainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found in keychain."
        case .duplicateItem:
            return "Duplicate item found in keychain."
        case .invalidItemFormat:
            return "Invalid item format."
        case .unexpectedStatus(let status):
            return "Unexpected status code: \(status)"
        }
    }
}

class KeychainService {
    static func save(_ value: String, forIdentifier identifier: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeyChainError.invalidItemFormat
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: data,
            kSecAttrAccessible as String:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeyChainError.unexpectedStatus(status)
        }
    }

    static func has(forIdentifier identifier: String) throws -> Bool {
        do {
            _ = try get(forIdentifier: identifier)
            return true
        } catch {
            return false
        }
    }

    static func get(forIdentifier identifier: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: true,
            kSecAttrAccessible as String:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            throw KeyChainError.unexpectedStatus(status)
        }

        guard let data = result as? Data,
            let value = String(data: data, encoding: .utf8)
        else {
            throw KeyChainError.invalidItemFormat
        }

        return value
    }

    static func delete(forIdentifier identifier: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unexpectedStatus(status)
        }
    }
}
