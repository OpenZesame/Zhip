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

extension Reactive: ZilliqaServiceReactive where Base: ZilliqaService {}
public extension Reactive where Base: ZilliqaService {

    func hasNetworkReachedConsensusYetForTransactionWith(id: String, polling: Polling) -> Observable<TransactionReceipt> {
        return callBase {
            $0.hasNetworkReachedConsensusYetForTransactionWith(id: id, polling: polling, done: $1)
        }
    }

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore keystore: Keystore) -> Observable<Bool> {
        return callBase {
            $0.verifyThat(encryptionPasshrase: encryptionPasshrase, canDecryptKeystore: keystore, done: $1)
        }
    }

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
            $0.getBalance(for: address, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, keystore: Keystore, passphrase: String) -> Observable<TransactionResponse> {
        return callBase {
            $0.sendTransaction(for: payment, keystore: keystore, passphrase: passphrase, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionResponse> {
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
                    single(.success(result))
                }
            })
            return Disposables.create {}
        }.asObservable()
    }
}
