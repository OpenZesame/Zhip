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
import CryptoSwift

public struct Keystore: Codable, Equatable {
    public static let minumumPasswordLength = 8

    public let address: LegacyAddress
    public let crypto: Crypto
    public let id: String
    public let version: Int
}

public extension Keystore {

    enum CodingKeys: CodingKey {
        /// JSON Keys matching those used by Zilliqa JavaScript library: https://github.com/Zilliqa/Zilliqa-Wallet/blob/master/src/app/zilliqa.service.ts
        case address, crypto, id, version
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeAddress() throws -> LegacyAddress {
            let addressHex = try container.decode(HexString.self, forKey: .address)
            return try LegacyAddress(unvalidatedHex: addressHex)
        }
        
        address = try decodeAddress()
        crypto = try container.decode(Crypto.self, forKey: .crypto)
        id = try container.decode(String.self, forKey: .id)
        version = try container.decode(Int.self, forKey: .version)
    }
}

// MARK: Initialization
public extension Keystore {
    init(address: LegacyAddress, crypto: Crypto, id: String? = nil, version: Int = 3) {
        self.address = address
        self.crypto = crypto
        self.id = id ?? UUID().uuidString
        self.version = version
    }

    init(
        from derivedKey: DerivedKey,
        privateKey: PrivateKey,
        kdf: KDF,
        parameters: KDFParams) throws {

        let crypto = try Keystore.Crypto(
            derivedKey: derivedKey,
            privateKey: privateKey,
            kdf: kdf,
            parameters: parameters
        )

        let address = LegacyAddress(privateKey: privateKey)

        self.init(address: address, crypto: crypto)
    }
}

public extension Keystore {
    func toJson() throws -> [String: Any] {
        return try asDictionary()
    }
}
