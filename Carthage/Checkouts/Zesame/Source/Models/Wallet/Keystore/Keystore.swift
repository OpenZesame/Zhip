//
//  Keystore.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
    static var minumumPasshraseLength: Int { return 8 }
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
    init(address: Address, crypto: Crypto, id: String? = nil, version: Int = 3) {
        self.address = address.address
        self.crypto = crypto
        self.id = id ?? UUID().uuidString
        self.version = version
    }

    init(from derivedKey: DerivedKey, for wallet: Wallet, parameters: Keystore.Crypto.KeyDerivationFunctionParameters) {
        self.init(
            address: wallet.address,
            crypto:
            Keystore.Crypto(derivedKey: derivedKey, wallet: wallet, parameters: parameters)
        )
    }
}


// MARK: Initialization
public extension Keystore.Crypto {

    /// Convenience
    init(derivedKey: DerivedKey, wallet: Wallet, parameters: Keystore.Crypto.KeyDerivationFunctionParameters) {

        /// initializationVector
        let iv = try! securelyGenerateBytes(count: 16).asData

        let aesCtr = try! AES(key: derivedKey.asData.prefix(16).bytes, blockMode: CTR(iv: iv.bytes))

        let encryptedPrivateKey = try! aesCtr.encrypt(wallet.keyPair.privateKey.bytes).asData

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
