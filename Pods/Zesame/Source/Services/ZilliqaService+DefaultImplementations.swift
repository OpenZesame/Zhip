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

    func createNewWallet(encryptionPassword: String, kdf: KDF = .default, done: @escaping Done<Wallet>) {
        background {
            let privateKey = PrivateKey.generateNew()
            let keyRestoration: KeyRestoration = .privateKey(privateKey, encryptBy: encryptionPassword, kdf: kdf)
            self.restoreWallet(from: keyRestoration, done: done)
        }
    }

    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>) {
        background { [unowned self] in
            switch restoration {
            case .keystore(let keystore, let password):
                keystore.decryptPrivateKeyWith(password: password) {
                    switch $0 {
                    case .failure(let error):
                        main {
                            done(.failure(error))
                        }
                    case .success(let privateKey):
                        // We would like the SDK to always store Keystore on same format, so disregarding if we imported a keystore having KDF `pbkdf2` or `scrypt`, the stored KDF in the users wallet
                        // is the same, so that decrypting takes ~same time for every user.
                        if keystore.crypto.kdf != KDF.default {
                            let defaultKeyRestoration: KeyRestoration = .privateKey(privateKey, encryptBy: password, kdf: .default)
                            self.restoreWallet(from: defaultKeyRestoration, done: done)
                        } else {
                            main {
                                let wallet = Wallet(keystore: keystore)
                                done(.success(wallet))
                            }
                        }
                    }
                }
            case .privateKey(let privateKey, let newPassword, let kdf):
                do {
                    try Keystore.from(privateKey: privateKey, encryptBy: newPassword, kdf: kdf) {

                        guard case .success(let keystore) = $0 else {
                            done(.failure($0.error!))
                            return
                        }

                        main {
                            done(.success(Wallet(keystore: keystore)))
                        }
                    }
                } catch {
                    main {
                        done(.failure(Error.walletImport(.keystoreError(error))))
                    }
                }
            }
        }
    }

    func exportKeystore(
        privateKey: PrivateKey,
        encryptWalletBy password: String,
        kdf: KDF = .default,
        done: @escaping Done<Keystore>
        ) {
        do {
            try Keystore.from(
                privateKey: privateKey,
                encryptBy: password,
                kdf: kdf,
                done: done
            )
        } catch {
           done(.failure(Error.keystoreExport(error)))
        }
    }
}
