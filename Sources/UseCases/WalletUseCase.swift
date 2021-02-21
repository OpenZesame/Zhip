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
