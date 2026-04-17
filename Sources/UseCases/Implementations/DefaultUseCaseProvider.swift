//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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
import KeychainSwift
import Zesame

extension KeyValueStore where KeyType == PreferencesKey {
    static var `default`: Preferences {
        KeyValueStore(UserDefaults.standard)
    }
}

let network: Network = .mainnet

final class DefaultUseCaseProvider {
    static let shared = DefaultUseCaseProvider(
        zilliqaService: DefaultZilliqaService(network: network).combine,
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
        DefaultTransactionsUseCase(
            zilliqaService: zilliqaService,
            securePersistence: securePersistence,
            preferences: preferences
        )
    }

    func makeOnboardingUseCase() -> OnboardingUseCase {
        DefaultOnboardingUseCase(
            zilliqaService: zilliqaService,
            preferences: preferences,
            securePersistence: securePersistence
        )
    }

    func makeWalletUseCase() -> WalletUseCase {
        DefaultWalletUseCase(zilliqaService: zilliqaService, securePersistence: securePersistence)
    }

    func makePincodeUseCase() -> PincodeUseCase {
        DefaultPincodeUseCase(preferences: preferences, securePersistence: securePersistence)
    }
}
