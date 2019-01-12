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
            keystore.decryptPrivateKeyWith(passphrase: encryptionPasshrase) { result in
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
                keystore.decryptPrivateKeyWith(passphrase: passphrase) {
                    switch $0 {
                    case .failure(let error):
                        main {
                            done(.failure(error))
                        }
                    case .success(_): // we dont want to use the private key that got decrypted, we only store keystore
                        do {
                            let address = try Address(string: keystore.address)
                            main {
                                done(.success(Wallet(keystore: keystore, address: address)))
                            }
                        } catch {
                            main {
                                done(.failure(.walletImport(.badAddress)))
                            }
                        }

                    }
                }
            case .privateKey(let privateKey, let newPassphrase):
                let address = AddressNotNecessarilyChecksummed(privateKey: privateKey)
                Keystore.from(address: address, privateKey: privateKey, encryptBy: newPassphrase) {
                    guard case .success(let keystore) = $0 else { done(Result.failure($0.error!)); return }
                    main {
                        done(.success(Wallet(keystore: keystore, address: address)))
                    }
                }
            }
        }
    }

    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy passphrase: String, done: @escaping Done<Keystore>) {
        Keystore.from(address: address, privateKey: privateKey, encryptBy: passphrase, done: done)
    }
}
