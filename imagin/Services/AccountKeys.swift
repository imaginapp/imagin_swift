//
//  AccountKeys.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import Foundation
import Logging
import stellarsdk

enum AccountKeysError: Error, LocalizedError {
    case noDefaultAccount
    case accountNotFound
    case invalidMnemonic
    case storeError(Error)

    var errorDescription: String? {
        switch self {
        case .noDefaultAccount:
            return "No default account found"
        case .accountNotFound:
            return "Account not found"
        case .invalidMnemonic:
            return "Invalid mnemonic phrase"
        case .storeError(let err):
            return "Error storing account: \(err.localizedDescription)"
        }
    }
}

class AccountKeys {
    static let defaultKey: String = "default"
    static let mnemonicIndex: Int = 0

    static let logger = Logger(label: "app.imagin.accountkeys")

    static func getDefaultAccount() throws -> KeyPair {
        do {
            let accountID = try KeychainService.get(forIdentifier: defaultKey)
            return try getKeyPair(forAccountID: accountID)
        } catch {
            logger.error(
                "Error retrieving default account",
                metadata: ["error": "\(error.localizedDescription)"]
            )
            throw AccountKeysError.noDefaultAccount
        }
    }

    static func getKeyPair(forAccountID accountID: String) throws -> KeyPair {
        do {
            let mnemonic = try KeychainService.get(forIdentifier: accountID)
            let keyPair = try WalletUtils.createKeyPair(
                mnemonic: mnemonic,
                passphrase: nil,
                index: mnemonicIndex
            )
            return keyPair
        } catch {
            logger.error(
                "Error retrieving keypair for account",
                metadata: ["error": "\(error.localizedDescription)"]
            )
            throw AccountKeysError.accountNotFound
        }
    }

    static func storeDefaultmnemonic(_ mnemonic: String) throws {
        do {
            let keyPair = try WalletUtils.createKeyPair(
                mnemonic: mnemonic,
                passphrase: nil,
                index: mnemonicIndex
            )
            try AccountKeys.storemnemonic(
                mnemonic,
                forAccountID: keyPair.accountId
            )
            try KeychainService.save(
                keyPair.accountId,
                forIdentifier: defaultKey
            )
        } catch {
            logger.error(
                "Error storing default mnemonic",
                metadata: ["error": "\(error.localizedDescription)"]
            )
            throw AccountKeysError.storeError(error)
        }
    }

    static func storemnemonic(
        _ mnemonic: String,
        forAccountID accountID: String
    ) throws {
        do {
            try KeychainService.save(mnemonic, forIdentifier: accountID)
        } catch {
            logger.error(
                "Error storing mnemonic",
                metadata: ["error": "\(error.localizedDescription)"]
            )
            throw AccountKeysError.storeError(error)
        }
    }

    static func hasDefaultAccount() -> Bool {
        do {
            return try KeychainService.has(forIdentifier: defaultKey)
        } catch {
            return false
        }
    }

    static func deleteAccount(accountID: String) throws {
        try KeychainService.delete(forIdentifier: accountID)

        // If we're deleting the default account, also remove the default reference
        if try KeychainService.get(forIdentifier: defaultKey) == accountID {
            try KeychainService.delete(forIdentifier: defaultKey)
        }
    }

}
