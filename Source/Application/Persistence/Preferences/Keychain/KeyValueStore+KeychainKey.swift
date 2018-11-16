//
//  KeyValueStore+KeychainKey.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

// MARK: - Wallet
extension KeyValueStore where KeyType == KeychainKey {
    var wallet: Wallet? {
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
