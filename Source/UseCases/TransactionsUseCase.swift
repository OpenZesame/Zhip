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

import RxSwift
import Zesame

protocol TransactionsUseCase {

    var cachedBalance: ZilAmount? { get }
    func cacheBalance(_ balance: ZilAmount)
    func getBalance(for address: AddressChecksummedConvertible) -> Observable<BalanceResponse>
    func deleteCachedBalance()
    var balanceUpdatedAt: Date? { get }
    func balanceWasUpdated(at date: Date)
    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassphrase: String) -> Observable<TransactionResponse>
    func receiptOfTransaction(byId txId: String, polling: Polling) -> Observable<TransactionReceipt>
}
