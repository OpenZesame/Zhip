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

import RxSwift
import JSONRPCKit
import APIKit
import Result
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

    func verifyThat(encryptionPasshrase: String, canDecryptKeystore keystore: Keystore) -> Observable<Bool> {
        return callBase {
            $0.verifyThat(encryptionPasshrase: encryptionPasshrase, canDecryptKeystore: keystore, done: $1)
        }
    }

    func createNewWallet(encryptionPassphrase: String) -> Observable<Wallet> {
        return callBase {
            $0.createNewWallet(encryptionPassphrase: encryptionPassphrase, done: $1)
        }
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>{
        return callBase {
            $0.restoreWallet(from: restoration, done: $1)
        }
    }

    func exportKeystore(address: AddressChecksummedConvertible, privateKey: PrivateKey, encryptWalletBy passphrase: String) -> Observable<Keystore> {
        return callBase {
            $0.exportKeystore(address: address, privateKey: privateKey, encryptWalletBy: passphrase, done: $1)
        }
    }

    func getBalance(for address: AddressChecksummedConvertible) -> Observable<BalanceResponse> {
        return callBase {
            $0.getBalance(for: address, done: $1)
        }
    }

    func sendTransaction(for payment: Payment, keystore: Keystore, passphrase: String, network: Network) -> Observable<TransactionResponse> {
        return callBase {
            $0.sendTransaction(for: payment, keystore: keystore, passphrase: passphrase, network: network, done: $1)
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
