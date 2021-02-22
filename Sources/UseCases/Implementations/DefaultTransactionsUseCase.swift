// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
    
    func getMinimumGasPrice() -> Observable<ZilAmount> {
        zilliqaService.getMinimumGasPrice(alsoUpdateLocallyCachedMinimum: true).map { $0.amount }
        
    }

    func getBalance(for address: LegacyAddress) -> Observable<BalanceResponse> {
        zilliqaService.getBalance(for: address)

    }

    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassword: String) -> Observable<TransactionResponse> {
        return zilliqaService.getNetworkFromAPI().flatMapLatest { [unowned self] in
            self.zilliqaService.sendTransaction(for: payment, keystore: wallet.keystore, password: encryptionPassword, network: $0.network)
        }
    }

    func receiptOfTransaction(byId txId: String, polling: Polling) -> Observable<TransactionReceipt> {
        return zilliqaService.hasNetworkReachedConsensusYetForTransactionWith(id: txId, polling: polling)
    }
}
