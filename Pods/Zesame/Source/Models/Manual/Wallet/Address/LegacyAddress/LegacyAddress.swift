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

/// Checksummed legacy Ethereum style address, looking like this: `F510333720c5Dd3c3C08bC8e085e8c981ce74691` can also be instantiated with a prefix of `0x`, like so: `0xF510333720c5Dd3c3C08bC8e085e8c981ce74691`
public struct LegacyAddress: AddressChecksummedConvertible, HexStringConvertible, Equatable {

    /// Checksummed hexstring representing the legacy Ethereum style address, e.g. `F510333720c5Dd3c3C08bC8e085e8c981ce74691`
    public let checksummed: HexString

    // AddressChecksummedConvertible init
    public init(hexString: HexStringConvertible) throws {
        guard LegacyAddress.isChecksummed(hexString: hexString) else {
            throw Address.Error.notChecksummed
        }
        self.checksummed = hexString.hexString
    }
}

// MARK: AddressChecksummedConvertible
public extension LegacyAddress {
    func toChecksummedLegacyAddress() throws -> LegacyAddress {
        return self
    }
}


// MARK: - Convenience Initializers
public extension LegacyAddress {
    init(string: String) throws {
        try self.init(hexString: try HexString(string))
    }
    
    init(compressedHash: Data) throws {
        let hexString = try HexString(compressedHash.toHexString())
        let checksummed = LegacyAddress.checksummedHexstringFrom(hexString: hexString)
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

// MARK: - HexStringConvertible
public extension LegacyAddress {
    var hexString: HexString { return checksummed }
}

/// Not necessarily checksummed

public extension LegacyAddress {
    static func isValidLegacyAddressButNotNecessarilyChecksummed(hexString: HexStringConvertible) throws {
        let length = hexString.length
        let expected = Address.Style.ethereum.expectedLength
        
        if length != expected {
            throw Address.Error.incorrectLength(expectedLength: expected, forStyle: Address.Style.ethereum, butGot: length)
        }
        // is valid
    }
    
    // AddressChecksummedConvertible init
    init(unvalidatedHex hexString: HexStringConvertible) throws {
        try LegacyAddress.isValidLegacyAddressButNotNecessarilyChecksummed(hexString: hexString)
        let checksummedHexString = LegacyAddress.checksummedHexstringFrom(hexString: hexString)
        try self.init(hexString: checksummedHexString)
    }
}
