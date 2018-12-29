//
//  Wallet.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

struct Wallet: Codable {
    let wallet: Zesame.Wallet
    let origin: Origin

    init(wallet: Zesame.Wallet, origin: Origin) {
        self.wallet = wallet
        self.origin = origin
    }

    // MARK: Origin
    enum Origin: Int, Codable {
        case generatedByThisApp
        case importedPrivateKey
        case importedKeystore
    }

    enum Error: Swift.Error {
        case isNil
    }
}

extension Wallet {
    var keystore: Keystore {
        return wallet.keystore
    }

    var address: Address {
        return wallet.address
    }
}
