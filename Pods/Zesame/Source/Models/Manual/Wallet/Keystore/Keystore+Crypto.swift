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
import CryptoSwift
import EllipticCurveKit

public extension Keystore {
    struct Crypto: Codable, Equatable {
        public struct CipherParameters: Codable, Equatable {
            /// "iv"
            let initializationVectorHex: String
            var initializationVector: Data { return Data(hex: initializationVectorHex) }

            public enum CodingKeys: String, CodingKey {
                case initializationVectorHex = "iv"
            }

            public init(initializationVectorHex: String) {
                self.initializationVectorHex = initializationVectorHex
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.initializationVectorHex = try container.decode(String.self, forKey: .initializationVectorHex)
            }
        }

        public static let cipherDefault = "aes-128-ctr"
        /// "cipher"
        let cipherType: String

        /// "cipherparams"
        let cipherParameters: CipherParameters

        let encryptedPrivateKeyHex: String
        var encryptedPrivateKey: Data { return Data(hex: encryptedPrivateKeyHex) }

        let kdf: KeyDerivationFunction

        /// "kdfparams"
        let keyDerivationFunctionParameters: KeyDerivationFunction.Parameters

        /// "mac"
        let messageAuthenticationCodeHex: String
        var messageAuthenticationCode: Data { return Data(hex: messageAuthenticationCodeHex) }

        public enum Error: Swift.Error {
            case encryptedPrivateKeyHexIncorrectLength(expectedLength: Int, butGot: Int)
            case saltHexIncorrectLength(expectedLength: Int, butGot: Int)
            case initializationVectorHexIncorrectLength(expectedLength: Int, butGot: Int)
            case macHexIncorrectLength(expectedLength: Int, butGot: Int)
        }

        public static let expectedLengthEncryptedPrivateKeyHex = 64
        public static let expectedLengthInitializationVectorHex = 32
        public static let expectedLengthMacHex = 64
        public static let expectedLengthSaltHex = 64

        public init(
            cipherType: String = Crypto.cipherDefault,
            cipherParameters: CipherParameters,
            encryptedPrivateKeyHex: String,
            kdf: KDF,
            kdfParams: KDFParams,
            messageAuthenticationCodeHex: String
            ) throws {

            guard encryptedPrivateKeyHex.count == Crypto.expectedLengthEncryptedPrivateKeyHex else {
                throw Error.encryptedPrivateKeyHexIncorrectLength(expectedLength: Crypto.expectedLengthEncryptedPrivateKeyHex, butGot: encryptedPrivateKeyHex.count)
            }

            guard cipherParameters.initializationVectorHex.count == Crypto.expectedLengthInitializationVectorHex else {
                throw Error.initializationVectorHexIncorrectLength(expectedLength: Crypto.expectedLengthInitializationVectorHex, butGot: cipherParameters.initializationVectorHex.count)
            }

            guard messageAuthenticationCodeHex.count == Crypto.expectedLengthMacHex else {
                throw Error.macHexIncorrectLength(expectedLength: Crypto.expectedLengthMacHex, butGot: messageAuthenticationCodeHex.count)
            }

            guard kdfParams.saltHex.count == Crypto.expectedLengthSaltHex else {
                throw Error.saltHexIncorrectLength(expectedLength: Crypto.expectedLengthSaltHex, butGot: kdfParams.saltHex.count)
            }

            self.cipherType = cipherType
            self.cipherParameters = cipherParameters
            self.encryptedPrivateKeyHex = encryptedPrivateKeyHex
            self.kdf = kdf
            self.keyDerivationFunctionParameters = kdfParams
            self.messageAuthenticationCodeHex = messageAuthenticationCodeHex
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let cipherType = try container.decode(String.self, forKey: .cipherType)
            let cipherParameters = try container.decode(CipherParameters.self, forKey: .cipherParameters)
            let encryptedPrivateKeyHex = try container.decode(String.self, forKey: .encryptedPrivateKeyHex)
            let kdf = try container.decode(KDF.self, forKey: .kdf)
            let keyDerivationFunctionParameters = try container.decode(KDFParams.self, forKey: .keyDerivationFunctionParameters)
            let messageAuthenticationCodeHex = try container.decode(String.self, forKey: .messageAuthenticationCodeHex)

            try self.init(
                cipherType: cipherType,
                cipherParameters: cipherParameters,
                encryptedPrivateKeyHex: encryptedPrivateKeyHex,
                kdf: kdf,
                kdfParams: keyDerivationFunctionParameters,
                messageAuthenticationCodeHex: messageAuthenticationCodeHex
            )
        }
    }
}


// MARK: - Codable
extension Keystore.Crypto {
    public enum CodingKeys: String, CodingKey {
        case cipherType = "cipher"
        case cipherParameters = "cipherparams"
        case encryptedPrivateKeyHex = "ciphertext"
        case kdf = "kdf"
        case keyDerivationFunctionParameters = "kdfparams"
        case messageAuthenticationCodeHex = "mac"
    }
}
