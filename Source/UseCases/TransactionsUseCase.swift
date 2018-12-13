//
//  TransactionsUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import Zesame

protocol TransactionsUseCase {

    func getBalance(for address: Address) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassphrase: String) -> Observable<TransactionResponse>
    func receiptOfTransaction(byId txId: String, polling: Polling) -> Observable<TransactionReceipt>
}
