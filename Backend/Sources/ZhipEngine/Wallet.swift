//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-11.
//

import Foundation
import Zesame

extension Zesame.Wallet: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.address == rhs.address
    }
}


public struct Wallet: Codable, Equatable {
    public let name: String?
    public let wallet: Zesame.Wallet
    public let origin: Origin

    public init(name: String?, wallet: Zesame.Wallet, origin: Origin) {
        self.name = name
        self.wallet = wallet
        self.origin = origin
    }
}

public extension Wallet {
    // MARK: Origin
    enum Origin: Int, Codable, Equatable {
        case generatedByThisApp
        case importedPrivateKey
        case importedKeystore
    }

    enum Error: Swift.Error {
        case isNil
    }
}

public extension Wallet {
    var keystore: Keystore {
        wallet.keystore
    }

    var bech32Address: Bech32Address {
        do {
            return try Bech32Address(ethStyleAddress: wallet.address, network: network)
        } catch { incorrectImplementation("should work") }
    }
    
    var legacyAddress: LegacyAddress {
        wallet.address
    }
}
