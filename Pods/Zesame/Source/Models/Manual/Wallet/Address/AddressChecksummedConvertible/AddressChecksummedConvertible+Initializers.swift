// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
