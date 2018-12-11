//
//  Address.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-05.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import CryptoSwift
import EllipticCurveKit

public struct Address {
    public static let lengthOfValidAddresses: Int = 40

    /// The compressed hashed data as a hexadecimal string
    /// which checksum has been confirmed to be correct.
    public let checksummedHex: HexString

    public init(hexString: HexString) throws {
        try Address.validateAddress(hexString: hexString)
        self.checksummedHex = Address.checksum(address: hexString)
    }
}

// MARK: - Convenience Initializers
public extension Address {

    init(compressedHash: Data) throws {
        try self.init(hexString: compressedHash.toHexString())
    }

    init?(uncheckedString: String) {
        do {
            try self.init(hexString: uncheckedString)
        } catch {
            return nil
        }
    }

    init(publicKey: PublicKey, network: Network) {
        let system = EllipticCurveKit.Zilliqa(network)
        let compressedHash = system.compressedHash(from: publicKey)
        do {
            try self.init(compressedHash: compressedHash)
        } catch {
            fatalError("Incorrect implementation, using `publicKey:network` initializer should never result in error: `\(error)`")
        }
    }

    init(keyPair: KeyPair, network: Network) {
        self.init(publicKey: keyPair.publicKey, network: network)
    }

    init(privateKey: PrivateKey, network: Network = .default) {
        let keyPair = KeyPair(private: privateKey)
        self.init(keyPair: keyPair, network: network)
    }
}

extension Address: Equatable {}

extension Address: ExpressibleByStringLiteral {}
public extension Address {
     init(stringLiteral value: String) {
        guard let address = Address(uncheckedString: value) else {
            fatalError("Incorrect implementation, pass non address formed string to init")
        }
        self = address
    }
}
