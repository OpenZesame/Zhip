//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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

    var balanceUpdatedAt: Date? {
        return preferences.loadValue(for: .balanceWasUpdatedAt)
    }

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
