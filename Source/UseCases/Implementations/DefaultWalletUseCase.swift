//
//  DefaultWalletUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame
import RxSwift

final class DefaultWalletUseCase {
    private let zilliqaService: ZilliqaServiceReactive
    let securePersistence: SecurePersistence
    init(zilliqaService: ZilliqaServiceReactive, securePersistence: SecurePersistence) {
        self.zilliqaService = zilliqaService
        self.securePersistence = securePersistence
    }
}

extension DefaultWalletUseCase: WalletUseCase, SecurePersisting {

    /// Checks if the passed `passphrase` was used to encypt the Keystore
    func verify(passhrase: String, forKeystore keystore: Keystore) -> Observable<Bool> {

        return zilliqaService.verifyThat(encryptionPasshrase: passhrase, canDecryptKeystore: keystore)
    }

    func extractKeyPairFrom(keystore: Keystore, encryptedBy passphrase: String) -> Observable<KeyPair> {
        return Observable.create { observer in

            keystore.toKeypair(encryptedBy: passphrase) {
                switch $0 {
                case .success(let keyPair):
                    observer.onNext(keyPair)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet> {
        return zilliqaService.createNewWallet(encryptionPassphrase: encryptionPassphrase).map {
            Wallet(wallet: $0, origin: .generatedByThisApp)
        }
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet> {
        return zilliqaService.restoreWallet(from: restoration).map {
            Wallet(wallet: $0, origin: .imported)
        }
    }
}
