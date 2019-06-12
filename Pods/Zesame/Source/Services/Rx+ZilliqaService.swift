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

import RxSwift


import EllipticCurveKit

extension Reactive: ZilliqaServiceReactive where Base: ZilliqaService {}
public extension Reactive where Base: ZilliqaService {

    func getNetworkFromAPI() -> Observable<NetworkResponse> {
        return callBase {
            $0.getNetworkFromAPI(done: $1)
        }
    }


    func hasNetworkReachedConsensusYetForTransactionWith(id: String, polling: Polling) -> Observable<TransactionReceipt> {
        return callBase {
            $0.hasNetworkReachedConsensusYetForTransactionWith(id: id, polling: polling, done: $1)
        }
    }

    func verifyThat(encryptionPassword: String, canDecryptKeystore keystore: Keystore) -> Observable<Bool> {
        return callBase {
            $0.verifyThat(encryptionPassword: encryptionPassword, canDecryptKeystore: keystore, done: $1)
        }
    }

    func createNewWallet(encryptionPassword: String, kdf: KDF = .default) -> Observable<Wallet> {
        return callBase {
            $0.createNewWallet(encryptionPassword: encryptionPassword, kdf: kdf, done: $1)
        }
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>{
        return callBase {
            $0.restoreWallet(from: restoration, done: $1)
        }
    }

    func exportKeystore(privateKey: PrivateKey, encryptWalletBy password: String) -> Observable<Keystore> {
        return callBase {
            $0.exportKeystore(privateKey: privateKey, encryptWalletBy: password, done: $1)
        }
    }

    func getBalance(for address: LegacyAddress) -> Observable<BalanceResponse> {
        return callBase {
            $0.getBalance(for: address, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, keystore: Keystore, password: String, network: Network) -> Observable<TransactionResponse> {
        return callBase {
            $0.sendTransaction(for: payment, keystore: keystore, password: password, network: network, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, signWith keyPair: KeyPair, network: Network) -> Observable<TransactionResponse> {
        return callBase {
            $0.sendTransaction(for: payment, signWith: keyPair, network: network, done: $1)
        }
    }

    func callBase<R>(call: @escaping (Base, @escaping Done<R>) -> Void) -> Observable<R> {
        return Single.create { [weak base] single in
            guard let strongBase = base else { return Disposables.create {} }
            call(strongBase, {
                switch $0 {
                case .failure(let error):
                    single(.error(error))
                case .success(let result):
                    single(.success(result))
                }
            })
            return Disposables.create {}
        }.asObservable()
    }
}
