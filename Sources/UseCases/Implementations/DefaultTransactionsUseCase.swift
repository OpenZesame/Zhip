// MIT License — Copyright (c) 2018-2026 Open Zesame
//
// RxSwift is retained here ONLY to bridge Zesame's Observable API to AnyPublisher.
// Once Zesame is migrated to Combine/async-await this file can drop the import.

import Combine
import Foundation
import RxSwift
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
    var cachedBalance: ZilAmount? {
        guard let qa: String = preferences.loadValue(for: .cachedBalance) else { return nil }
        return try? ZilAmount(qa: qa)
    }

    var balanceUpdatedAt: Date? { preferences.loadValue(for: .balanceWasUpdatedAt) }

    func balanceWasUpdated(at date: Date) {
        preferences.save(value: date, for: .balanceWasUpdatedAt)
    }

    func deleteCachedBalance() {
        preferences.deleteValue(for: .cachedBalance)
        preferences.deleteValue(for: .balanceWasUpdatedAt)
    }

    func cacheBalance(_ balance: ZilAmount) {
        preferences.save(value: balance.qaString, for: .cachedBalance)
        balanceWasUpdated(at: Date())
    }

    func getMinimumGasPrice() -> AnyPublisher<ZilAmount, Error> {
        zilliqaService.getMinimumGasPrice(alsoUpdateLocallyCachedMinimum: true)
            .map(\.amount)
            .asAnyPublisher()
    }

    func getBalance(for address: LegacyAddress) -> AnyPublisher<BalanceResponse, Error> {
        zilliqaService.getBalance(for: address).asAnyPublisher()
    }

    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassword: String)
        -> AnyPublisher<TransactionResponse, Error> {
        zilliqaService.getNetworkFromAPI()
            .flatMapLatest { [unowned self] in
                zilliqaService.sendTransaction(
                    for: payment,
                    keystore: wallet.keystore,
                    password: encryptionPassword,
                    network: $0.network
                )
            }
            .asAnyPublisher()
    }

    func receiptOfTransaction(byId txId: String, polling: Polling) -> AnyPublisher<TransactionReceipt, Error> {
        zilliqaService.hasNetworkReachedConsensusYetForTransactionWith(id: txId, polling: polling)
            .asAnyPublisher()
    }
}

// MARK: - Observable → AnyPublisher bridge (Zesame ↔ Combine)

private extension ObservableConvertibleType {
    func asAnyPublisher() -> AnyPublisher<Element, Error> {
        let relay = PassthroughSubject<Element, Never>()
        var rxDisposable: RxSwift.Disposable?
        rxDisposable = self.asObservable().subscribe(
            onNext: { relay.send($0) },
            onError: { _ in relay.send(completion: .finished) },
            onCompleted: { relay.send(completion: .finished) }
        )
        return relay
            .handleEvents(receiveCancel: { rxDisposable?.dispose() })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
