//
//  MockedWalletUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

@testable import Zhip

import RxSwift
import RxCocoa
import RxBlocking
import RxTest

import Zesame

final class MockedWalletUseCase: WalletUseCase {
    func extractKeyPairFrom(keystore: Keystore, encryptedBy passphrase: String) -> Observable<KeyPair> {
        abstract
    }

    var wallet: Zhip.Wallet?
    var hasLoadWalletBeenCalled = false

    init(wallet: Zhip.Wallet) {
        self.wallet = wallet
    }

    func createNewWallet(encryptionPassphrase: String) -> Observable<Zhip.Wallet> {
        abstract
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Zhip.Wallet> {
        abstract
    }

    func save(wallet: Zhip.Wallet) {
        self.wallet = wallet
    }

    func deleteWallet() {
        wallet = nil
    }

    func verify(passhrase: String, forKeystore keystore: Keystore) -> Observable<Bool> {
        abstract
    }

    func loadWallet() -> Zhip.Wallet? {
        hasLoadWalletBeenCalled = true
        return wallet
    }

    var hasConfiguredWallet: Bool {
        return wallet != nil
    }
}
