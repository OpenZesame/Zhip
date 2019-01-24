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
import EllipticCurveKit
import JSONRPCKit
import Result
import APIKit
import RxSwift
import CryptoSwift

public protocol ZilliqaService: AnyObject {
    var apiClient: APIClient { get }

    func getNetworkFromAPI(done: @escaping Done<NetworkResponse>)

    func verifyThat(encryptionPassword: String, canDecryptKeystore: Keystore, done: @escaping Done<Bool>)
    func createNewWallet(encryptionPassword: String, done: @escaping Done<Wallet>)
    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>)
    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy password: String, done: @escaping Done<Keystore>)

    func getBalance(for address: AddressChecksummedConvertible, done: @escaping Done<BalanceResponse>)
    func send(transaction: SignedTransaction, done: @escaping Done<TransactionResponse>)
}

public protocol ZilliqaServiceReactive {

    func getNetworkFromAPI() -> Observable<NetworkResponse>
    func verifyThat(encryptionPassword: String, canDecryptKeystore: Keystore) -> Observable<Bool>
    func createNewWallet(encryptionPassword: String) -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy password: String) -> Observable<Keystore>
    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) -> Observable<KeyPair>

    func getBalance(for address: AddressChecksummedConvertible) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, keystore: Keystore, password: String, network: Network) -> Observable<TransactionResponse>
    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair, network: Network) -> Observable<TransactionResponse>

    func hasNetworkReachedConsensusYetForTransactionWith(id: String, polling: Polling) -> Observable<TransactionReceipt>
}

public extension ZilliqaServiceReactive {

    func extractKeyPairFrom(wallet: Wallet, encryptedBy password: String) -> Observable<KeyPair> {
        return extractKeyPairFrom(keystore: wallet.keystore, encryptedBy: password)
    }

    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) -> Observable<KeyPair> {
        return Observable.create { observer in

            keystore.toKeypair(encryptedBy: password) {
                switch $0 {
                case .success(let keyPair):
                    observer.onNext(keyPair)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func hasNetworkReachedConsensusYetForTransactionWith(id: String) -> Observable<TransactionReceipt> {
        return hasNetworkReachedConsensusYetForTransactionWith(id: id, polling: .twentyTimesLinearBackoff)
    }

}
