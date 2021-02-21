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

final class DefaultWalletUseCase: WalletUseCase, SecurePersisting {
    private let zilliqaService: ZilliqaServiceReactive
    let securePersistence: SecurePersistence
    init(zilliqaService: ZilliqaServiceReactive, securePersistence: SecurePersistence) {
        self.zilliqaService = zilliqaService
        self.securePersistence = securePersistence
    }
}

extension DefaultWalletUseCase {

    /// Checks if the passed `password` was used to encypt the Keystore
    func verify(Password: String, forKeystore keystore: Keystore) -> Observable<Bool> {

        return zilliqaService.verifyThat(encryptionPassword: Password, canDecryptKeystore: keystore)
    }

    func extractKeyPairFrom(keystore: Keystore, encryptedBy password: String) -> Observable<KeyPair> {
        return zilliqaService.extractKeyPairFrom(keystore: keystore, encryptedBy: password)
    }

    func createNewWallet(encryptionPassword: String) -> Observable<Wallet> {
        return zilliqaService.createNewWallet(encryptionPassword: encryptionPassword, kdf: .default).map {
            Wallet(wallet: $0, origin: .generatedByThisApp)
        }
    }

    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet> {
        let origin: Wallet.Origin
        switch restoration {
        case .keystore: origin = .importedKeystore
        case .privateKey: origin = .importedPrivateKey
        }
        return zilliqaService.restoreWallet(from: restoration).map {
            Wallet(wallet: $0, origin: origin)
        }
    }
}
