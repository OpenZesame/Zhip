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
public struct Keystore {

    public let address: String
    public let crypto: Crypto
    public let id: String
    public let version: Int
}

public extension Keystore {
    static var minumumPasswordLength: Int { return 2 }
}

extension Keystore {
    public struct Crypto {

        /// "cipher"
        let cipherType: String = "aes-128-ctr"

        /// "cipherparams"
        let cipherParameters: CipherParameters

        let encryptedPrivateKeyHex: String
        var encryptedPrivateKey: Data { return Data(hex: encryptedPrivateKeyHex) }

        /// "kdf"
        let keyDerivationFunction: String = "scrypt"

        /// "kdfparams"
        let keyDerivationFunctionParameters: KeyDerivationFunctionParameters

        /// "mac"
        let messageAuthenticationCodeHex: String
        var messageAuthenticationCode: Data { return Data(hex: messageAuthenticationCodeHex) }
    }
}

extension Keystore.Crypto {
    public struct CipherParameters {
        /// "iv"
        let initializationVectorHex: String
        var initializationVector: Data { return Data(hex: initializationVectorHex) }
    }

    public struct KeyDerivationFunctionParameters {
        /// "N", CPU/memory cost parameter, must be power of 2.
        let costParameter: Int

        /// "r", blocksize
        let blockSize: Int

        /// "p"
        let parallelizationParameter: Int

        /// "dklen"
        let lengthOfDerivedKey: Int

        let saltHex: String
        var salt: Data { return Data(hex: saltHex) }
    }
}

extension Keystore.Crypto: Codable, Equatable {
    public enum CodingKeys: String, CodingKey {
        case cipherType = "cipher"
        case cipherParameters = "cipherparams"
        case encryptedPrivateKeyHex = "ciphertext"
        case keyDerivationFunction = "kdf"
        case keyDerivationFunctionParameters = "kdfparams"
        case messageAuthenticationCodeHex = "mac"
    }
}

extension Keystore.Crypto.CipherParameters: Codable, Equatable {
    public enum CodingKeys: String, CodingKey {
        case initializationVectorHex = "iv"
    }
}

extension Keystore.Crypto.KeyDerivationFunctionParameters: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        /// Should be lowercase "n", since that is what Zilliqa JS SDK uses
        case costParameter = "n"
        case blockSize = "r"
        case parallelizationParameter = "p"
        case lengthOfDerivedKey = "dklen"

        case saltHex = "salt"
    }
}

public extension Keystore {
    init(address: AddressChecksummedConvertible, crypto: Crypto, id: String? = nil, version: Int = 3) {
        self.address = address.asString
        self.crypto = crypto
        self.id = id ?? UUID().uuidString
        self.version = version
    }

    init(from derivedKey: DerivedKey, address: AddressChecksummedConvertible, privateKey: PrivateKey, parameters: Keystore.Crypto.KeyDerivationFunctionParameters) {
        self.init(
            address: address,
            crypto:
            Keystore.Crypto(derivedKey: derivedKey, privateKey: privateKey, parameters: parameters)
        )
    }
}

// MARK: Initialization
public extension Keystore.Crypto {

    /// Convenience
    init(derivedKey: DerivedKey, privateKey: PrivateKey, parameters: Keystore.Crypto.KeyDerivationFunctionParameters) {

        /// initializationVector
        let iv = try! securelyGenerateBytes(count: 16).asData

        let aesCtr = try! AES(key: derivedKey.asData.prefix(16).bytes, blockMode: CTR(iv: iv.bytes))

        let encryptedPrivateKey = try! aesCtr.encrypt(privateKey.bytes).asData

        let mac = (derivedKey.asData.suffix(16) + encryptedPrivateKey).asData.sha3(.sha256)

        self.init(
            cipherParameters:
            Keystore.Crypto.CipherParameters(initializationVectorHex: iv.asHex),
            encryptedPrivateKeyHex: encryptedPrivateKey.asHex,
            keyDerivationFunctionParameters: parameters,
            messageAuthenticationCodeHex: mac.asHex)
    }
}

extension Keystore: Codable, Equatable {}

public extension Keystore {
    func toJson() -> [String: Any] {
        return try! asDictionary()
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
