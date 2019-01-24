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
