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
        return zilliqaService.createNewWallet(encryptionPassword: encryptionPassword).map {
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
