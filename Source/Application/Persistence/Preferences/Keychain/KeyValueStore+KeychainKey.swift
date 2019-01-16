//
//  KeyValueStore+KeychainKey.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

// MARK: - Wallet
extension KeyValueStore where KeyType == KeychainKey {
    var wallet: Wallet? {
        // Delete wallet upon reinstall if needed. This makes sure that after a reinstall of the app, the flag
        // `hasRunAppBefore`, which recides in UserDefaults - which gets reset after uninstalls, will be false
        // thus we should not have any wallet configured. Delete previous one if needed and always return nil
        guard Preferences.default.isTrue(.hasRunAppBefore) else {
            Preferences.default.save(value: true, for: .hasRunAppBefore)
            deleteWallet()
            deletePincode()
            Preferences.default.deleteValue(for: .cachedBalance)
            Preferences.default.deleteValue(for: .balanceWasUpdatedAt)
            return nil
        }
        return loadCodable(Wallet.self, for: .keystore)
    }

    var hasConfiguredWallet: Bool {
        return wallet != nil
    }

    func save(wallet: Wallet) {
        saveCodable(wallet, for: .keystore)
    }

    func deleteWallet() {
        deleteValue(for: .keystore)
    }
}

extension KeyValueStore where KeyType == KeychainKey {

    var pincode: Pincode? {
        return loadCodable(Pincode.self, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    var hasConfiguredPincode: Bool {
        return pincode != nil
    }

    func save(pincode: Pincode) {
        saveCodable(pincode, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    func deletePincode() {
        deleteValue(for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }
}
