//
//  Rx+ZilliqaService.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

import RxSwift
import JSONRPCKit
import APIKit
import Result

extension Reactive: ZilliqaServiceReactive where Base: (ZilliqaService & AnyObject) {

    public func createNewWallet() -> Observable<Wallet> {
        return callBase {
            $0.createNewWallet(done: $1)
        }
    }

    public func exportKeystore(from wallet: Wallet, encryptWalletBy passphrase: String) -> Observable<Keystore> {
        return callBase {
            $0.exportKeystore(from: wallet, encryptWalletBy: passphrase, done: $1)
        }
    }

    public func importWalletFrom(keyStore: Keystore, encryptedBy passphrase: String) -> Observable<Wallet> {
        return callBase {
            $0.importWalletFrom(keyStore: keyStore, encryptedBy: passphrase, done: $1)
        }
    }

    public func getBalance(for address: Address) -> Observable<BalanceResponse> {
        return callBase {
            $0.getBalalance(for: address, done: $1)
        }
    }

    public func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionIdentifier> {
        return callBase {
            $0.sendTransaction(for: payment, signWith: keyPair, done: $1)
        }
    }

    private func callBase<R>(call: @escaping (Base, @escaping Done<R>) -> Void) -> Observable<R> {
        return Single.create { [weak base] single in
            guard let strongBase = base else { return Disposables.create {} }
            call(strongBase, {
                switch $0 {
                case .failure(let error):
                    print("⚠️ API request failed, error: '\(error)'")
                    single(.error(error))
                case .success(let result):
                    print("🎉 API request successful, response: '\(String(describing: result))'")
                    single(.success(result))
                }
            })
            return Disposables.create {}
        }.asObservable()
    }
}
