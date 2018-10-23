//
//  Keystore+Wallet+Import.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import CryptoSwift
import Result

public extension Keystore {

    func toKeypair(encryptedBy passphrase: String, done: @escaping Done<KeyPair>) {
        decryptPrivateKey(using: passphrase) {
            switch $0 {
            case .failure(let error): done(Result.failure(error))
            case .success(let privateKeyHex):
                let keyPair = KeyPair(privateKeyHex: privateKeyHex)!
                done(.success(keyPair))
            }
        }
    }

    func decryptPrivateKey(using passphrase: String, done: @escaping Done<String>) {
        guard passphrase.count >= Keystore.minumumPasshraseLength else { done(.failure(.keystorePasshraseTooShort(provided: passphrase.count, minimum: Keystore.minumumPasshraseLength))); return }

        let encryptedPrivateKey = crypto.encryptedPrivateKey

        Scrypt(kdfParameters: crypto.keyDerivationFunctionParameters).deriveKey(passphrase: passphrase) { derivedKey in
            let mac = (derivedKey.asData.suffix(16) + encryptedPrivateKey).sha3(.sha256)
            guard mac == self.crypto.messageAuthenticationCode else { done(.failure(.walletImport(.incorrectPasshrase))); return }

            let aesCtr = try! AES(key: derivedKey.asData.prefix(16).bytes, blockMode: CTR(iv: self.crypto.cipherParameters.initializationVector.bytes))
            let decryptedPrivateKey = try! aesCtr.decrypt(encryptedPrivateKey.bytes).asHex
            done(.success(decryptedPrivateKey))
        }
    }
}
