// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation
import Zesame

protocol TransactionsUseCase {
    var cachedBalance: ZilAmount? { get }
    func cacheBalance(_ balance: ZilAmount)
    func getMinimumGasPrice() -> AnyPublisher<ZilAmount, Error>
    func getBalance(for address: LegacyAddress) -> AnyPublisher<BalanceResponse, Error>
    func deleteCachedBalance()
    var balanceUpdatedAt: Date? { get }
    func balanceWasUpdated(at date: Date)
    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassword: String)
        -> AnyPublisher<TransactionResponse, Error>
    func receiptOfTransaction(byId txId: String, polling: Polling) -> AnyPublisher<TransactionReceipt, Error>
}
