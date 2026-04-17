// MIT License — Copyright (c) 2018-2026 Open Zesame

import Combine
import Foundation
import Zesame

final class DefaultTransactionsUseCase {
    private let zilliqaService: ZilliqaServiceReactive
    let securePersistence: SecurePersistence
    let preferences: Preferences

    init(zilliqaService: ZilliqaServiceReactive, securePersistence: SecurePersistence, preferences: Preferences) {
        self.zilliqaService = zilliqaService
        self.securePersistence = securePersistence
        self.preferences = preferences
    }
}

extension DefaultTransactionsUseCase: TransactionsUseCase {
    var cachedBalance: Amount? {
        guard let qa: String = preferences.loadValue(for: .cachedBalance) else { return nil }
        return try? Amount(qa: qa)
    }

    var balanceUpdatedAt: Date? { preferences.loadValue(for: .balanceWasUpdatedAt) }

    func balanceWasUpdated(at date: Date) {
        preferences.save(value: date, for: .balanceWasUpdatedAt)
    }

    func deleteCachedBalance() {
        preferences.deleteValue(for: .cachedBalance)
        preferences.deleteValue(for: .balanceWasUpdatedAt)
    }

    func cacheBalance(_ balance: Amount) {
        preferences.save(value: balance.qaString, for: .cachedBalance)
        balanceWasUpdated(at: Date())
    }

    func getMinimumGasPrice() -> AnyPublisher<Amount, Swift.Error> {
        zilliqaService.getMinimumGasPrice(alsoUpdateLocallyCachedMinimum: true)
            .map(\.amount)
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }

    func getBalance(for address: LegacyAddress) -> AnyPublisher<BalanceResponse, Swift.Error> {
        zilliqaService.getBalance(for: address)
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }

    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassword: String)
        -> AnyPublisher<TransactionResponse, Swift.Error> {
        zilliqaService.getNetworkFromAPI()
            .flatMapLatest { [unowned self] networkResponse in
                zilliqaService.sendTransaction(
                    for: payment,
                    keystore: wallet.keystore,
                    password: encryptionPassword,
                    network: networkResponse.network
                )
            }
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }

    func receiptOfTransaction(byId txId: String, polling: Polling) -> AnyPublisher<TransactionReceipt, Swift.Error> {
        zilliqaService.hasNetworkReachedConsensusYetForTransactionWith(id: txId, polling: polling)
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }
}
