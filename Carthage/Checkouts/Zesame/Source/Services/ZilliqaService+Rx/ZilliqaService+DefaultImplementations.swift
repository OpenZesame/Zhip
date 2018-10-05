//
//  ZilliqaService+DefaultImplementations.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-23.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Result
import EllipticCurveKit
import CryptoSwift

public extension ZilliqaService {

    func createNewWallet(done: @escaping Done<Wallet>) {
        background {
            let newWallet = Wallet(keyPair: KeyPair(private: PrivateKey.generateNew()), network: Network.testnet)
            main {
                done(Result.success(newWallet))
            }
        }
    }

    func exportKeystore(from wallet: Wallet, encryptWalletBy passphrase: String, done: @escaping Done<Keystore>){
        guard passphrase.count >= Keystore.minumumPasshraseLength else { done(.failure(.keystorePasshraseTooShort(provided: passphrase.count, minimum: Keystore.minumumPasshraseLength))); return }

        // Same parameters used by Zilliqa Javascript SDK: https://github.com/Zilliqa/Zilliqa-Wallet/blob/master/src/app/zilliqa.service.ts#L142
        let salt = try! securelyGenerateBytes(count: 32).asData
        let kdfParams = Keystore.Crypto.KeyDerivationFunctionParameters(
            costParameter: 2048,
            blockSize: 1,
            parallelizationParameter: 8,
            lengthOfDerivedKey: 32,
            saltHex: salt.asHex
        )

        Scrypt(kdfParameters: kdfParams).deriveKey(passphrase: passphrase) { derivedKey in
            let keyStore = Keystore(from: derivedKey, for: wallet, parameters: kdfParams)
            done(Result.success(keyStore))
        }
    }

    func importWalletFrom(keyStore: Keystore, encryptedBy passphrase: String, done: @escaping Done<Wallet>) {
        guard passphrase.count >= Keystore.minumumPasshraseLength else { done(.failure(.keystorePasshraseTooShort(provided: passphrase.count, minimum: Keystore.minumumPasshraseLength))); return }

        let encryptedPrivateKey = keyStore.crypto.encryptedPrivateKey

        Scrypt(kdfParameters: keyStore.crypto.keyDerivationFunctionParameters).deriveKey(passphrase: passphrase) { derivedKey in
            let mac = (derivedKey.asData.suffix(16) + encryptedPrivateKey).sha3(.sha256)
            guard mac == keyStore.crypto.messageAuthenticationCode else { done(.failure(.walletImport(.incorrectPasshrase))); return }

            let aesCtr = try! AES(key: derivedKey.asData.prefix(16).bytes, blockMode: CTR(iv: keyStore.crypto.cipherParameters.initializationVector.bytes))
            let decryptedPrivateKey = try! aesCtr.decrypt(encryptedPrivateKey.bytes).asHex
            let wallet = Wallet(privateKeyHex: decryptedPrivateKey)!
            done(.success(wallet))
        }
    }
}

// MARK: - Wallet Import + JSON support
public extension ZilliqaService {
    func importWalletFrom(keyStoreJSON: Data, encryptedBy passphrase: String, done: @escaping Done<Wallet>) {
        do {
            let keyStore = try JSONDecoder().decode(Keystore.self, from: keyStoreJSON)
            importWalletFrom(keyStore: keyStore, encryptedBy: passphrase, done: done)
        } catch let error as Swift.DecodingError {
            done(Result.failure(Error.walletImport(.jsonDecoding(error))))
        } catch { fatalError("incorrect implementation") }
    }

    func importWalletFrom(keyStoreJSONString: String, encodedBy encoding: String.Encoding = .utf8, encryptedBy passphrase: String, done: @escaping Done<Wallet>) {
        guard let json = keyStoreJSONString.data(using: encoding) else { done(.failure(.walletImport(.jsonStringDecoding))); return }
        importWalletFrom(keyStoreJSON: json, encryptedBy: passphrase, done: done)
    }
}
