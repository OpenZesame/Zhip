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

import CryptoSwift
import EllipticCurveKit

public extension Keystore {

    func toKeypair(encryptedBy password: String, done: @escaping Done<KeyPair>) {
        decryptPrivateKeyWith(password: password) {
                switch $0 {
                case .failure(let error): done(Result.failure(error))
                case .success(let privateKey):
                    let keyPair = KeyPair(private: privateKey)
                    done(.success(keyPair))
                }
        }
    }

    func decryptPrivateKeyWith(password: String, done: @escaping Done<PrivateKey>) {

        guard password.count >= Keystore.minumumPasswordLength else {
            let error = Error.keystorePasswordTooShort(
                provided: password.count,
                minimum: Keystore.minumumPasswordLength
            )
            done(.failure(error))
            return
        }

        let encryptedPrivateKey = crypto.encryptedPrivateKey
        let iv = crypto.cipherParameters.initializationVector
        let cipher = crypto.cipherType
        let expectedMAC = crypto.messageAuthenticationCodeHex.uppercased()
        do {
            try deriveKey(password: password) { derivedKey in
                let MAC = try calculateMac(derivedKey: derivedKey, encryptedPrivateKey: encryptedPrivateKey, iv: iv, cipherType: cipher).asHex.uppercased()

                guard MAC == expectedMAC else {
                    let error = Error.walletImport(.incorrectPassword)
                    done(.failure(error))
                    return
                }

                let aesCtr = try makeAesCtr(derivedKey: derivedKey, iv: iv)

                let decryptedPrivateKey = try aesCtr.decrypt(encryptedPrivateKey.bytes).asHex
                guard let privateKey = PrivateKey(hex: decryptedPrivateKey) else {
                    let error = Error.walletImport(.badPrivateKeyHex)
                    done(.failure(error))
                    return
                }
                done(.success(privateKey))
            }
        } catch {
            done(.failure(Error.decryptPrivateKey(error)))
        }
    }
}

private func calculateMac(
    derivedKey: DerivedKey,
    encryptedPrivateKey: Data,
    iv: Data,
    cipherType: String? = nil
    ) throws -> Data {

    let cipher = cipherType ?? Keystore.Crypto.cipherDefault
    let algo = cipher.data(using: .utf8)!

    return try HMAC(
        key: derivedKey.bytes,
        variant: .sha256
    ).authenticate(
        ((derivedKey.asData.suffix(16) + encryptedPrivateKey + iv + algo) as DataConvertible).bytes
    ).asData
}

private func makeAesCtr(derivedKey: DerivedKey, iv: Data) throws -> AES {
    return try AES(
        key: derivedKey.asData.prefix(16).bytes,
        blockMode: CTR(iv: iv.bytes),
        padding: Padding.noPadding
    )
}

// MARK: - Convenience Init
public extension Keystore.Crypto {
    /// Following Zilliqa JS lib for encrypting of private key: https://github.com/Zilliqa/Zilliqa-JavaScript-Library/blob/ad3b46343435571d2799758a6c5011dfa5cc2881/packages/zilliqa-js-crypto/src/keystore.ts#L68-L125
    init(
        derivedKey: DerivedKey,
        privateKey: PrivateKey,
        kdf: KDF,
        parameters: KDFParams
        ) throws {

        /// initializationVector
        let iv = try securelyGenerateBytes(count: 16).asData

        let aesCtr = try makeAesCtr(derivedKey: derivedKey, iv: iv)

        let encryptedPrivateKey = try aesCtr.encrypt(privateKey.bytes).asData

        let mac = try calculateMac(derivedKey: derivedKey, encryptedPrivateKey: encryptedPrivateKey, iv: iv)

        try self.init(
            cipherParameters:
            Keystore.Crypto.CipherParameters(initializationVectorHex: iv.asHex),
            encryptedPrivateKeyHex: encryptedPrivateKey.asHex,
            kdf: kdf,
            kdfParams: parameters,
            messageAuthenticationCodeHex: mac.asHex)
    }
}
