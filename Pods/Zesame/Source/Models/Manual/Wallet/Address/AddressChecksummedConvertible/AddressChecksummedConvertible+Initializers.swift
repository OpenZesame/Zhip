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
