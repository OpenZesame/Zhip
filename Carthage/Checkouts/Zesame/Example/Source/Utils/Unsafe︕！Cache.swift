//
//  Unsafe︕！Cache.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

/// ⚠️ THIS IS TERRIBLE! DONT USE THIS! This is HIGHLY unsafe and secure. It is temporary and will be removed soon.
struct Unsafe︕！Cache {
    enum Key: String {
        case unsafePrivateKeyHex
    }

    static func stringForKey(_ key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }

    static var wallet: Wallet? {
        guard let privateKeyHex = Unsafe︕！Cache.privateKeyHex else { return nil }
        return Wallet(privateKeyHex: privateKeyHex)
    }

    static var isWalletConfigured: Bool {
        return wallet != nil
    }



    static var privateKeyHex: String? {
        return stringForKey(.unsafePrivateKeyHex)
    }

    /// ⚠️ THIS IS TERRIBLE! DONT USE THIS!
    static func unsafe︕！Store(value: Any, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    /// ⚠️ THIS IS TERRIBLE! DONT USE THIS!
    static func unsafe︕！Store(wallet: Wallet) {
        unsafe︕！Store(value: wallet.keyPair.privateKey.asHexStringLength64(), forKey: .unsafePrivateKeyHex)
    }

    static func deleteWallet() {
        deleteValueFor(key: .unsafePrivateKeyHex)
    }

    static func deleteValueFor(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
