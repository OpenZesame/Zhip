//
//  Wallet.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import EllipticCurveKit

public typealias Curve = Secp256k1
public typealias KeyPair = EllipticCurveKit.KeyPair<Curve>
public typealias PrivateKey = EllipticCurveKit.PrivateKey<Curve>
public typealias PublicKey = EllipticCurveKit.PublicKey<Curve>
public typealias Signature = EllipticCurveKit.Signature<Curve>
public typealias Signer = EllipticCurveKit.AnyKeySigner<Schnorr<Curve>>
public typealias Network = EllipticCurveKit.Zilliqa.Network

public extension Network {
    static var `default`: Network {
        return .mainnet
    }
}

public struct Wallet {
    public let keyPair: KeyPair
    public let address: Address
    public let balance: Amount
    public let nonce: Nonce
    public let network: Network

    public init(keyPair: KeyPair, network: Network = .default, balance: Amount = 0, nonce: Nonce = 0) {
        self.keyPair = keyPair
        self.address = Address(keyPair: keyPair, network: network)
        self.balance = balance
        self.network = network
        self.nonce = nonce
    }
}

public extension Wallet {
    init?(privateKeyHex: String, network: Network = .default, balance: Amount = 0, nonce: Nonce = 0) {
        guard let keyPair = KeyPair(privateKeyHex: privateKeyHex) else { return nil }
        self.init(keyPair: keyPair, network: network, balance: balance, nonce: nonce)
    }
}

extension Wallet: CustomStringConvertible {}
public extension Wallet {
    var description: String {
        return """
            address: '\(address)'
            publicKey: '\(keyPair.publicKey)'
            balance: '\(balance)'
        """
    }
}

extension EllipticCurveKit.PublicKey: CustomStringConvertible {
    public var description: String {
        return hex.compressed
    }
}
