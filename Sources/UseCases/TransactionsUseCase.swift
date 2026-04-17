// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation
import Zesame

protocol TransactionsUseCase {
    var cachedBalance: Amount? { get }
    func cacheBalance(_ balance: Amount)
    func getMinimumGasPrice() -> AnyPublisher<Amount, Swift.Error>
    func getBalance(for address: LegacyAddress) -> AnyPublisher<BalanceResponse, Swift.Error>
    func deleteCachedBalance()
    var balanceUpdatedAt: Date? { get }
    func balanceWasUpdated(at date: Date)
    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassword: String)
        -> AnyPublisher<TransactionResponse, Swift.Error>
    func receiptOfTransaction(byId txId: String, polling: Polling) -> AnyPublisher<TransactionReceipt, Swift.Error>
}
