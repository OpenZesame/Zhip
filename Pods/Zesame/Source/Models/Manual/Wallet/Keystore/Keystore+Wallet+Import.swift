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

        deriveKey(password: password) { derivedKey in
            let mac = (derivedKey.asData.suffix(16) + encryptedPrivateKey).sha3(.sha256)

            guard mac == self.crypto.messageAuthenticationCode else {
                let error = Error.walletImport(.incorrectPassword)
                done(.failure(error))
                return
            }

            let aesCtr = try! AES(
                key: derivedKey.asData.prefix(16).bytes,
                blockMode: CTR(iv: self.crypto.cipherParameters.initializationVector.bytes)
            )

            let decryptedPrivateKey = try! aesCtr.decrypt(encryptedPrivateKey.bytes).asHex

            done(.success(decryptedPrivateKey))
        }
    }
}
