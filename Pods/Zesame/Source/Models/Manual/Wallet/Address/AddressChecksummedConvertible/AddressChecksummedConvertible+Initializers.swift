//
//  AddressChecksummedConvertible+Initializers.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit

// MARK: - Convenience Initializers
public extension AddressChecksummedConvertible {
    init(string: String) throws {
        try self.init(hexString: try HexString(string))
    }

    init(compressedHash: Data) throws {
        let hexString = try HexString(compressedHash.toHexString())
        let checksummed = AddressChecksummed.checksummedHexstringFrom(hexString: hexString)
        try self.init(hexString: checksummed)
    }

    init(publicKey: PublicKey) {
        do {
            // Zilliqa is actually using Bitcoins hashing of public keys settings for address formatting, and
            // Zilliqa does not distinct between mainnet and testnet in the addresses. However, Zilliqa does
            // make a distinction in terms of chain id for transaction to either testnet or mainnet. See
            // the enum `Network` (in this project) for more info
            try self.init(compressedHash: EllipticCurveKit.Zilliqa.init(.mainnet).compressedHash(from: publicKey))
        } catch {
            fatalError("Incorrect implementation, using `publicKey` initializer should never result in error: `\(error)`")
        }
    }

    init(keyPair: KeyPair) {
        self.init(publicKey: keyPair.publicKey)
    }

    init(privateKey: PrivateKey) {
        let keyPair = KeyPair(private: privateKey)
        self.init(keyPair: keyPair)
    }
}
