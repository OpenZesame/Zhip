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

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore: Keystore, done: @escaping Done<Bool>)
    func createNewWallet(encryptionPassphrase: String, done: @escaping Done<Wallet>)
    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>)
    func exportKeystore(address: Address, privateKey: PrivateKey, encryptWalletBy passphrase: String, done: @escaping Done<Keystore>)

    func getBalalance(for address: Address, done: @escaping Done<BalanceResponse>)
    func send(transaction: SignedTransaction, done: @escaping Done<TransactionResponse>)
}

public protocol ZilliqaServiceReactive {

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore: Keystore) -> Observable<Bool>
    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
    func exportKeystore(address: Address, privateKey: PrivateKey, encryptWalletBy passphrase: String) -> Observable<Keystore>

    func getBalance(for address: Address) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, keystore: Keystore, passphrase: String) -> Observable<TransactionResponse>
    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair) -> Observable<TransactionResponse>
}
