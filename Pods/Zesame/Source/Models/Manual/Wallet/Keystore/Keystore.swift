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

/// JSON Keys matching those used by Zilliqa JavaScript library: https://github.com/Zilliqa/Zilliqa-Wallet/blob/master/src/app/zilliqa.service.ts
public struct Keystore: Codable, Equatable {
    public static let minumumPasswordLength = 2

    public let address: AddressChecksummed
    public let crypto: Crypto
    public let id: String
    public let version: Int
}

// MARK: Initialization
public extension Keystore {
    init(address: AddressChecksummedConvertible, crypto: Crypto, id: String? = nil, version: Int = 3) {
        self.address = address.checksummedAddress
        self.crypto = crypto
        self.id = id ?? UUID().uuidString
        self.version = version
    }

    init(
        from derivedKey: DerivedKey,
        privateKey: PrivateKey,
        kdf: KDF,
        parameters: KDFParams) {

        let crypto = Keystore.Crypto(
            derivedKey: derivedKey,
            privateKey: privateKey,
            kdf: kdf,
            parameters: parameters
        )

        let address = AddressChecksummed(privateKey: privateKey)

        self.init(address: address, crypto: crypto)
    }
}

public extension Keystore {
    func toJson() -> [String: Any] {
        return try! asDictionary()
    }
}
