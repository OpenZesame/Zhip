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
        guard password.count >= Keystore.minumumPasswordLength else { done(.failure(.keystorePasswordTooShort(provided: password.count, minimum: Keystore.minumumPasswordLength))); return }

        let encryptedPrivateKey = crypto.encryptedPrivateKey

        Scrypt(kdfParameters: crypto.keyDerivationFunctionParameters).deriveKey(password: password) { derivedKey in
            let mac = (derivedKey.asData.suffix(16) + encryptedPrivateKey).sha3(.sha256)
            guard mac == self.crypto.messageAuthenticationCode else { done(.failure(.walletImport(.incorrectPassword))); return }

            let aesCtr = try! AES(key: derivedKey.asData.prefix(16).bytes, blockMode: CTR(iv: self.crypto.cipherParameters.initializationVector.bytes))
            let decryptedPrivateKey = try! aesCtr.decrypt(encryptedPrivateKey.bytes).asHex
            done(.success(decryptedPrivateKey))
        }
    }
}
