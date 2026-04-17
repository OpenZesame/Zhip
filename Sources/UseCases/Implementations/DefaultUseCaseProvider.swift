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

    /// The app-wide default `Preferences` store, backed by `UserDefaults.standard`.
    static var `default`: Preferences {
        KeyValueStore(UserDefaults.standard)
    }
}

/// The Zilliqa network this build targets. Currently wired to `.mainnet`.
///
/// When we add staging/testnet builds this will move into a build-configuration
/// driven registration on `Container.shared.zilliqaService`.
let network: Network = .mainnet

/// Default `UseCaseProvider` implementation.
///
/// Retained for compatibility with coordinators that take a `UseCaseProvider` in
/// their initializers. New code should resolve individual use cases directly from
/// `Container.shared` — see `Container.swift` for the full factory list.
final class DefaultUseCaseProvider {

    /// Singleton seeded with production services. Coordinators that haven't yet
    /// migrated to `Container.shared` still use this entry point.
    static let shared = DefaultUseCaseProvider(
        zilliqaService: DefaultZilliqaService(network: network).combine,
        preferences: .default,
        securePersistence: KeyValueStore(KeychainSwift())
    )

    /// Reactive Zesame façade shared with every spawned use case.
    private let zilliqaService: ZilliqaServiceReactive

    /// Non-secret key-value store (UserDefaults in production).
    private let preferences: Preferences

    /// Secret key-value store (Keychain in production).
    private let securePersistence: SecurePersistence

    /// Designated initializer — inject stand-ins in tests to exercise the provider
    /// in isolation.
    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences, securePersistence: SecurePersistence) {
        self.zilliqaService = zilliqaService
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

extension DefaultUseCaseProvider: UseCaseProvider {

    /// Spawns a fresh `DefaultTransactionsUseCase` backed by the provider's services.
    func makeTransactionsUseCase() -> TransactionsUseCase {
        DefaultTransactionsUseCase(
            zilliqaService: zilliqaService,
            securePersistence: securePersistence,
            preferences: preferences
        )
    }

    /// Spawns a fresh `DefaultOnboardingUseCase`.
    func makeOnboardingUseCase() -> OnboardingUseCase {
        DefaultOnboardingUseCase(
            zilliqaService: zilliqaService,
            preferences: preferences,
            securePersistence: securePersistence
        )
    }

    /// Spawns a fresh `DefaultWalletUseCase`.
    func makeWalletUseCase() -> WalletUseCase {
        DefaultWalletUseCase(zilliqaService: zilliqaService, securePersistence: securePersistence)
    }

    /// Spawns a fresh `DefaultPincodeUseCase`.
    func makePincodeUseCase() -> PincodeUseCase {
        DefaultPincodeUseCase(preferences: preferences, securePersistence: securePersistence)
    }
}
