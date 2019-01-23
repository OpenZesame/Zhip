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
import KeychainSwift

extension KeyValueStore where KeyType == PreferencesKey {
    static var `default`: Preferences {
        return KeyValueStore(UserDefaults.standard)
    }
}

final class DefaultUseCaseProvider {

    static let zilliqaNetwork: Network = .testnet(.prod)

    static let shared = DefaultUseCaseProvider(
        zilliqaService: DefaultZilliqaService(network: zilliqaNetwork).rx,
        preferences: .default,
        securePersistence: KeyValueStore(KeychainSwift())
    )

    private let zilliqaService: ZilliqaServiceReactive
    private let preferences: Preferences
    private let securePersistence: SecurePersistence

    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences, securePersistence: SecurePersistence) {
        self.zilliqaService = zilliqaService
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

extension DefaultUseCaseProvider: UseCaseProvider {
    func makeTransactionsUseCase() -> TransactionsUseCase {
        return DefaultTransactionsUseCase(zilliqaService: zilliqaService, securePersistence: securePersistence, preferences: preferences)
    }

    func makeOnboardingUseCase() -> OnboardingUseCase {
        return DefaultOnboardingUseCase(zilliqaService: zilliqaService, preferences: preferences, securePersistence: securePersistence)
    }

    func makeWalletUseCase() -> WalletUseCase {
        return DefaultWalletUseCase(zilliqaService: zilliqaService, securePersistence: securePersistence)
    }

    func makePincodeUseCase() -> PincodeUseCase {
        return DefaultPincodeUseCase(preferences: preferences, securePersistence: securePersistence)
    }
}
