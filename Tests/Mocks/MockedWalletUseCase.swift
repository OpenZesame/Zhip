//
//  MockedWalletUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

@testable import Zupreme

import RxSwift
import RxCocoa
import RxBlocking
import RxTest

import Zesame

final class MockedWalletUseCase: WalletUseCase {

    var wallet: Zupreme.Wallet?
    var hasLoadWalletBeenCalled = false

    init(wallet: Zupreme.Wallet) {
        self.wallet = wallet
    }

    func createNewWallet(encryptionPassphrase: String) -> Observable<Zupreme.Wallet> {
        abstract
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Zupreme.Wallet> {
        abstract
    }

    func save(wallet: Zupreme.Wallet) {
        self.wallet = wallet
    }

    func deleteWallet() {
        wallet = nil
    }

    func verify(passhrase: String, forKeystore keystore: Keystore) -> Observable<Bool> {
        abstract
    }

    func loadWallet() -> Zupreme.Wallet? {
        hasLoadWalletBeenCalled = true
        return wallet
    }

    var hasConfiguredWallet: Bool {
        return wallet != nil
    }
}
