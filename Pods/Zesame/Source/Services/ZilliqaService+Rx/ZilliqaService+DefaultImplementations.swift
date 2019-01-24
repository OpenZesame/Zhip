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

import Foundation
import Result
import EllipticCurveKit
import CryptoSwift

public extension ZilliqaService {

    func verifyThat(encryptionPassword: String, canDecryptKeystore keystore: Keystore, done: @escaping Done<Bool>) {
        background {
            keystore.decryptPrivateKeyWith(password: encryptionPassword) { result in
                main {
                    done(.success(result.value != nil))
                }
            }
        }
    }

    func createNewWallet(encryptionPassword: String, done: @escaping Done<Wallet>) {
        background {
            let privateKey = PrivateKey.generateNew()
            let keyRestoration: KeyRestoration = .privateKey(privateKey, encryptBy: encryptionPassword)
            self.restoreWallet(from: keyRestoration, done: done)
        }
    }


    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>) {
        background {
            switch restoration {
            case .keystore(let keystore, let password):
                keystore.decryptPrivateKeyWith(password: password) {
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
            case .privateKey(let privateKey, let newPassword):
                let address = AddressNotNecessarilyChecksummed(privateKey: privateKey)
                Keystore.from(address: address, privateKey: privateKey, encryptBy: newPassword) {
                    guard case .success(let keystore) = $0 else { done(Result.failure($0.error!)); return }
                    main {
                        done(.success(Wallet(keystore: keystore, address: address)))
                    }
                }
            }
        }
    }

    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy password: String, done: @escaping Done<Keystore>) {
        Keystore.from(address: address, privateKey: privateKey, encryptBy: password, done: done)
    }
}
