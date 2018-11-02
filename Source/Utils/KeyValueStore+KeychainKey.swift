//
//  KeyValueStore+KeychainKey.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

extension KeyValueStore where KeyType == KeychainKey {
    var wallet: Wallet? {
        guard
            let walletJson: Data = loadValue(for: .keystore),
            let wallet = try? JSONDecoder().decode(Wallet.self, from: walletJson)
            else { return nil }
        return wallet
    }

    func save(wallet: Wallet) {
        guard let walletJson = try? JSONEncoder().encode(wallet) else { return }
        save(value: walletJson, for: .keystore)
    }

    func removeWallet() {
        deleteValue(for: .keystore)
    }
}
