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
import EllipticCurveKit

extension Reactive: ZilliqaServiceReactive where Base: (ZilliqaService & AnyObject) {}
public extension Reactive where Base: (ZilliqaService & AnyObject) {

    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet> {
        return callBase {
            $0.createNewWallet(encryptionPassphrase: encryptionPassphrase, done: $1)
        }
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>{
        return callBase {
            $0.restoreWallet(from: restoration, done: $1)
        }
    }

    func exportKeystore(address: Address, privateKey: PrivateKey, encryptWalletBy passphrase: String) -> Observable<Keystore> {
        return callBase {
            $0.exportKeystore(address: address, privateKey: privateKey, encryptWalletBy: passphrase, done: $1)
        }
    }

    func getBalance(for address: Address) -> Observable<BalanceResponse> {
        return callBase {
            $0.getBalalance(for: address, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, keystore: Keystore, passphrase: String) -> Observable<TransactionIdentifier> {
        return callBase {
            $0.sendTransaction(for: payment, keystore: keystore, passphrase: passphrase, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionIdentifier> {
        return callBase {
            $0.sendTransaction(for: payment, signWith: keyPair, done: $1)
        }
    }

    func callBase<R>(call: @escaping (Base, @escaping Done<R>) -> Void) -> Observable<R> {
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
