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
import EllipticCurveKit

import RxSwift
import CryptoSwift

public protocol ZilliqaService: AnyObject {
    var apiClient: APIClient { get }

    func getNetworkFromAPI(done: @escaping Done<NetworkResponse>)

    func verifyThat(encryptionPassword: String, canDecryptKeystore: Keystore, done: @escaping Done<Bool>)
    func createNewWallet(encryptionPassword: String, kdf: KDF, done: @escaping Done<Wallet>)
    func restoreWallet(from restoration: KeyRestoration, done: @escaping Done<Wallet>)
    func exportKeystore(privateKey: PrivateKey, encryptWalletBy password: String, kdf: KDF, done: @escaping Done<Keystore>)

    func getBalance(for address: LegacyAddress, done: @escaping Done<BalanceResponse>)
    func send(transaction: SignedTransaction, done: @escaping Done<TransactionResponse>)
}

public protocol ZilliqaServiceReactive {

    func getNetworkFromAPI() -> Observable<NetworkResponse>
    func verifyThat(encryptionPassword: String, canDecryptKeystore: Keystore) -> Observable<Bool>
    func createNewWallet(encryptionPassword: String, kdf: KDF) -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
    func exportKeystore(privateKey: PrivateKey, encryptWalletBy password: String) -> Observable<Keystore>
    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) -> Observable<KeyPair>

    func getBalance(for address: LegacyAddress) -> Observable<BalanceResponse>
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
            background {
                keystore.toKeypair(encryptedBy: password) {
                    switch $0 {
                    case .success(let keyPair):
                        main {
                            observer.onNext(keyPair)
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        main {
                            observer.onError(error)
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }

    func hasNetworkReachedConsensusYetForTransactionWith(id: String) -> Observable<TransactionReceipt> {
        return hasNetworkReachedConsensusYetForTransactionWith(id: id, polling: .twentyTimesLinearBackoff)
    }

}
