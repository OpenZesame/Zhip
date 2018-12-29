//
//  MockedTransactionUseCase.swift
//  ZupremeTests
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

final class MockedTransactionUseCase: TransactionsUseCase {

    var mockedBalanceResponse: BalanceResponse
    var hasGetBalanceBeenCalled = false

    init(balance: BalanceResponse) {
        self.mockedBalanceResponse = balance
    }

    func getBalance(for address: Address) -> Observable<BalanceResponse> {
        hasGetBalanceBeenCalled = true
        return .just(mockedBalanceResponse)
    }

    func sendTransaction(for payment: Payment, wallet: Zupreme.Wallet, encryptionPassphrase: String) -> Observable<TransactionResponse> {
        abstract
    }

    func receiptOfTransaction(byId txId: String, polling: Polling) -> Observable<TransactionReceipt> {
        abstract
    }
}

// MARK: BalanceResponse Init
extension BalanceResponse: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        try! self.init(ZilAmount(significand: value))
    }

    init(_ balance: ZilAmount, nonce: Nonce = 0) {
        let json = """
            {
            "balance": "\(balance.significand)",
            "nonce": \(nonce.nonce)
            }
            """.data(using: .utf8)!
        self = try! JSONDecoder().decode(BalanceResponse.self, from: json)
    }
}
