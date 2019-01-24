//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
