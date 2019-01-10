//
//  TransactionsUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import Zesame

protocol TransactionsUseCase {

    var cachedBalance: ZilAmount? { get }
    func cacheBalance(_ balance: ZilAmount)
    func getBalance(for address: Address) -> Observable<BalanceResponse>
    func deleteCachedBalance()
    var balanceUpdatedAt: Date? { get }
    func balanceWasUpdated(at date: Date)
    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassphrase: String) -> Observable<TransactionResponse>
    func receiptOfTransaction(byId txId: String, polling: Polling) -> Observable<TransactionReceipt>
}
