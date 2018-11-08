//
//  WalletLoading.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

import Zesame

import RxSwift
import RxCocoa

protocol SecurePersisting: AnyObject {
    var securePersistence: SecurePersistence { get }
}

protocol WalletUseCase: AnyObject {
    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
    func save(wallet: Wallet)
    func deleteWallet()

    /// Checks if the passed `passphrase` was used to encypt the Keystore
    func verify(passhrase: String, forKeystore keystore: Keystore) -> Observable<Bool>
    func loadWallet() -> Wallet?
    var hasWalletConfigured: Bool { get }
}

extension WalletUseCase {

    /// Checks if the passed `passphrase` was used to encypt the Keystore inside the Wallet
    func verify(passhrase: String, forWallet wallet: Wallet) -> Observable<Bool> {
        return verify(passhrase: passhrase, forKeystore: wallet.keystore)
    }
}

extension WalletUseCase where Self: SecurePersisting {

    func deleteWallet() {
        securePersistence.deleteWallet()
    }

    func loadWallet() -> Wallet? {
        return securePersistence.wallet
    }

    func save(wallet: Wallet) {
        securePersistence.save(wallet: wallet)
    }

    var hasWalletConfigured: Bool {
        return securePersistence.hasWalletConfigured
    }
}

extension WalletUseCase {
    var wallet: Observable<Wallet?> {
        return Single.create { [unowned self] single in
            single(.success(self.loadWallet()))
            return Disposables.create {}
        }
        .asObservable()
    }
}
