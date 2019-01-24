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
import RxCocoa

protocol SecurePersisting: AnyObject {
    var securePersistence: SecurePersistence { get }
}

protocol WalletUseCase: AnyObject {
    func createNewWallet(encryptionPassword: String) -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
    func save(wallet: Wallet)
    func deleteWallet()

    /// Checks if the passed `password` was used to encypt the Keystore
    func verify(Password: String, forKeystore keystore: Keystore) -> Observable<Bool>
    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) -> Observable<KeyPair>
    func loadWallet() -> Wallet?
    var hasConfiguredWallet: Bool { get }
}

extension WalletUseCase {

    /// Checks if the passed `password` was used to encypt the Keystore inside the Wallet
    func verify(Password: String, forWallet wallet: Wallet) -> Observable<Bool> {
        return verify(Password: Password, forKeystore: wallet.keystore)
    }

    func extractKeyPairFrom(wallet: Wallet, encryptedBy password: String) -> Observable<KeyPair> {
        return extractKeyPairFrom(keystore: wallet.keystore, encryptedBy: password)
    }
}

extension WalletUseCase where Self: SecurePersisting {

    func deleteWallet() {
        securePersistence.deleteWallet()
    }

    func loadWallet() -> Wallet? {
        return securePersistence.wallet
    }

    func save(wallet: Wallet) {
        securePersistence.save(wallet: wallet)
    }

    var hasConfiguredWallet: Bool {
        return securePersistence.hasConfiguredWallet
    }
}

extension WalletUseCase {
    var wallet: Observable<Wallet?> {
        return Single.create { [unowned self] single in
            single(.success(self.loadWallet()))
            return Disposables.create {}
        }
        .asObservable()
    }
}
