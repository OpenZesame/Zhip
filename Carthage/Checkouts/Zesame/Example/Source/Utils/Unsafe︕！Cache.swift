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
        case wallet
    }

    static func stringForKey(_ key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }

    static func dataForKey(_ key: Key) -> Data? {
        return UserDefaults.standard.data(forKey: key.rawValue)
    }

    static var wallet: Wallet? {
        guard
            let walletData = Unsafe︕！Cache.dataForKey(.wallet),
        let wallet = try? JSONDecoder().decode(Wallet.self, from: walletData)
        else { return nil }
        return wallet
    }

    static var isWalletConfigured: Bool {
        return wallet != nil
    }

    static func unsafe︕！Store(value: Any, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func unsafe︕！Store(wallet: Wallet) {
        let data = try! JSONEncoder().encode(wallet)
        unsafe︕！Store(value: data, forKey: .wallet)
    }

    static func deleteWallet() {
        deleteValueFor(key: .wallet)
    }

    static func deleteValueFor(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
