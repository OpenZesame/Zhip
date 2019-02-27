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
import Result
import EllipticCurveKit

public extension Keystore {

    func toKeypair(encryptedBy password: String, done: @escaping Done<KeyPair>) {
        decryptPrivateKeyWith(password: password) {
            switch $0 {
            case .failure(let error): done(Result.failure(error))
            case .success(let privateKeyHex):
                let keyPair = KeyPair(privateKeyHex: privateKeyHex)!
                done(.success(keyPair))
            }
        }
    }

    func decryptPrivateKeyWith(password: String, done: @escaping Done<String>) {

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

        deriveKey(password: password) { derivedKey in
            let MAC = calculateMac(derivedKey: derivedKey, encryptedPrivateKey: encryptedPrivateKey, iv: iv, cipherType: cipher).asHex.uppercased()

            guard MAC == expectedMAC else {
                let error = Error.walletImport(.incorrectPassword)
                done(.failure(error))
                return
            }

            let aesCtr = try! AES(
                key: derivedKey.asData.prefix(16).bytes,
                blockMode: CTR(iv: iv.bytes)
            )

            let decryptedPrivateKey = try! aesCtr.decrypt(encryptedPrivateKey.bytes).asHex

            done(.success(decryptedPrivateKey))
        }
    }
}

private func calculateMac(
    derivedKey: DerivedKey,
    encryptedPrivateKey: Data,
    iv: Data,
    cipherType: String? = nil
    ) -> Data {

    let cipher = cipherType ?? Keystore.Crypto.cipherDefault
    let algo = cipher.data(using: .utf8)!

    return try! HMAC(
        key: derivedKey.bytes,
        variant: .sha256
    ).authenticate(
        ((derivedKey.asData.suffix(16) + encryptedPrivateKey + iv + algo) as DataConvertible).bytes
    ).asData
}

// MARK: - Convenience Init
public extension Keystore.Crypto {
    init(
        derivedKey: DerivedKey,
        privateKey: PrivateKey,
        kdf: KDF,
        parameters: KDFParams
        ) {

        /// initializationVector
        let iv = try! securelyGenerateBytes(count: 16).asData

        let aesCtr = try! AES(key: derivedKey.asData.prefix(16).bytes, blockMode: CTR(iv: iv.bytes))

        let encryptedPrivateKey = try! aesCtr.encrypt(privateKey.bytes).asData

        let mac = calculateMac(derivedKey: derivedKey, encryptedPrivateKey: encryptedPrivateKey, iv: iv)

        self.init(
            cipherParameters:
            Keystore.Crypto.CipherParameters(initializationVectorHex: iv.asHex),
            encryptedPrivateKeyHex: encryptedPrivateKey.asHex,
            kdf: kdf,
            kdfParams: parameters,
            messageAuthenticationCodeHex: mac.asHex)
    }
}
