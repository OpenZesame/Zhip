//
//  TransactionsUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame
import RxSwift

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
        guard let qa: String = preferences.loadValue(for: .cachedBalance) else {
            return nil
        }
        return try? ZilAmount(qa: qa)
    }

    func deleteCachedBalance() {
        preferences.deleteValue(for: .cachedBalance)
    }

    func cacheBalance(_ balance: ZilAmount) {
        preferences.save(value: balance.qaString, for: .cachedBalance)
    }

    func getBalance(for address: AddressChecksummedConvertible) -> Observable<BalanceResponse> {
        return zilliqaService.getBalance(for: address)
    }

    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassphrase: String) -> Observable<TransactionResponse> {
        return zilliqaService.sendTransaction(for: payment, keystore: wallet.keystore, passphrase: encryptionPassphrase)
    }

    func receiptOfTransaction(byId txId: String, polling: Polling) -> Observable<TransactionReceipt> {
        return zilliqaService.hasNetworkReachedConsensusYetForTransactionWith(id: txId, polling: polling)
    }
}
