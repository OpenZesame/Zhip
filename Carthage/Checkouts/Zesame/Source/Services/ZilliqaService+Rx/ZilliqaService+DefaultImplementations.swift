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

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore keystore: Keystore, done: @escaping Done<Bool>) {
        background {
            keystore.decryptPrivateKey(using: encryptionPasshrase) { result in
                main {
                    done(.success(result.value != nil))
                }
            }
        }
    }

    func createNewWallet(encryptionPassphrase: String, done: @escaping Done<Wallet>) {
        background {
            let privateKey = PrivateKey.generateNew()
            let keyRestoration: KeyRestoration = .privateKey(privateKey, encryptBy: encryptionPassphrase)
            self.restoreWallet(from: keyRestoration, done: done)
        }
    }


    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>) {
        background {
            switch restoration {
            case .keystore(let keystore, let passphrase):
                keystore.decryptPrivateKey(using: passphrase) {
                    switch $0 {
                    case .failure(let error):
                        main {
                            done(.failure(error))
                        }
                    case .success:
                        guard let address = Address(uncheckedString: keystore.address) else {
                            done(.failure(.walletImport(.badAddress)))
                            return
                        }
                        main {
                            done(.success(Wallet(keystore: keystore, address: address)))
                        }
                    }
                }
            case .privateKey(let privateKey, let newPassphrase):
                let address = Address(privateKey: privateKey)
                Keystore.from(address: address, privateKey: privateKey, encryptBy: newPassphrase) {
                    guard case .success(let keystore) = $0 else { done(Result.failure($0.error!)); return }
                    main {
                        done(.success(Wallet(keystore: keystore, address: address)))
                    }
                }
            }
        }
    }

    func exportKeystore(address: Address, privateKey: PrivateKey, encryptWalletBy passphrase: String, done: @escaping Done<Keystore>) {
        Keystore.from(address: address, privateKey: privateKey, encryptBy: passphrase, done: done)
    }
}
