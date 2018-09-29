//
//  ZilliqaService.swift
//  Zesame iOS
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import EllipticCurveKit
import JSONRPCKit
import Result
import APIKit
import RxSwift
import CryptoSwift

public protocol ZilliqaService {
    var apiClient: APIClient { get }

    func createNewWallet(done: @escaping Done<Wallet>)
    func exportKeystore(from wallet: Wallet, encryptWalletBy passphrase: String, done: @escaping Done<Keystore>)
    func importWalletFrom(keyStore: Keystore, encryptedBy passphrase: String, done: @escaping Done<Wallet>)

    func getBalalance(for address: Address, done: @escaping Done<BalanceResponse>)
    func send(transaction: Transaction, done: @escaping Done<TransactionIdentifier>)
}

public protocol ZilliqaServiceReactive {
    func createNewWallet() -> Observable<Wallet>
    func exportKeystore(from wallet: Wallet, encryptWalletBy passphrase: String) -> Observable<Keystore>
    func importWalletFrom(keyStore: Keystore, encryptedBy passphrase: String) -> Observable<Wallet>

    func getBalance(for address: Address) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionIdentifier>
}
