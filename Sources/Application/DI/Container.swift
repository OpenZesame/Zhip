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

// MARK: - Factory<T>

/// A lightweight, Factory-compatible DI primitive.
///
/// `Factory` holds a registered closure that constructs a dependency. Callers invoke
/// the factory as `someFactory()` (the `callAsFunction` overload below) to obtain a
/// freshly-resolved instance, and tests can swap implementations via
/// `register { ... }`, restoring the original closure with `reset()` in `tearDown`.
///
/// The shape of the API (`register`, `reset`, `callAsFunction`) mirrors
/// [hmlongco/Factory](https://github.com/hmlongco/Factory) so that a future migration
/// to the real SPM package is a near-no-op: delete this file, add the SPM dependency,
/// and replace `import Foundation` with `import Factory` in call sites.
///
/// `Factory` is **not** thread-safe. Register dependencies once (typically at app
/// launch) from the main thread.
final class Factory<T> {

    /// The closure originally supplied to `init`. Stored separately from `_current`
    /// so `reset()` can restore it after a test-time `register`.
    private let defaultFactory: () -> T

    /// The currently-active closure; replaced by `register(_:)` during tests.
    private var _current: () -> T

    /// Creates a new factory from an initial build closure.
    ///
    /// `factory` is evaluated **every** time `callAsFunction` is invoked, so each
    /// resolution yields a fresh instance unless the closure itself returns a cached
    /// value.
    init(_ factory: @escaping () -> T) {
        defaultFactory = factory
        _current = factory
    }

    /// Overrides the stored factory closure. Typically used by tests to swap in a
    /// mock; call `reset()` in `tearDown` to restore the original closure.
    @discardableResult
    func register(_ factory: @escaping () -> T) -> Self {
        _current = factory
        return self
    }

    /// Restores the factory closure to the one originally passed into `init`.
    func reset() {
        _current = defaultFactory
    }

    /// Resolves the dependency. Invoked via the implicit function-call syntax
    /// (`container.walletUseCase()`).
    func callAsFunction() -> T {
        _current()
    }
}

// MARK: - Container

/// Shared dependency container.
///
/// `Container.shared` is the single source of truth for every injected dependency in
/// the app. Production code resolves dependencies from it
/// (`Container.shared.walletUseCase()`), and tests register mocks against the same
/// container (`Container.shared.walletUseCase.register { MockWalletUseCase() }`)
/// before calling `reset()` in `tearDown`.
///
/// All registrations live on this type directly; once the codebase grows, we can
/// split the factories into separate `Container+*` extensions the way real Factory
/// encourages.
final class Container {

    /// The process-wide shared container.
    static let shared = Container()

    /// Hidden initializer to enforce the single shared instance.
    private init() {}

    // MARK: - Services (low-level dependencies)

    /// The reactive façade over `Zesame` blockchain operations. Shared across every
    /// use case so they all talk to the same underlying service instance.
    lazy var zilliqaService: Factory<ZilliqaServiceReactive> = _register { () -> ZilliqaServiceReactive in
        DefaultZilliqaService(network: .mainnet).combine
    }

    /// The `UserDefaults`-backed key-value store for non-secret preferences.
    lazy var preferences: Factory<Preferences> = _register { () -> Preferences in
        KeyValueStore(UserDefaults.standard)
    }

    /// The Keychain-backed secure store for wallet material and pincode.
    lazy var securePersistence: Factory<SecurePersistence> = _register { () -> SecurePersistence in
        KeyValueStore(KeychainSwift())
    }

    // MARK: - Use cases

    /// Factory for the composite `WalletUseCase`.
    ///
    /// Prefer depending on one of the narrow `CreateWalletUseCase`,
    /// `RestoreWalletUseCase`, `WalletStorageUseCase`, `VerifyEncryptionPasswordUseCase`,
    /// or `ExtractKeyPairUseCase` protocols in new code — the default factories below
    /// resolve the same shared `DefaultWalletUseCase` so overriding any of them in a
    /// test substitutes a mock for every caller of that narrow protocol.
    lazy var walletUseCase: Factory<WalletUseCase> = _register { [unowned self] () -> WalletUseCase in
        DefaultWalletUseCase(
            zilliqaService: self.zilliqaService(),
            securePersistence: self.securePersistence()
        )
    }

    /// Factory for the composite `TransactionsUseCase`.
    lazy var transactionsUseCase: Factory<TransactionsUseCase> = _register { [unowned self] () -> TransactionsUseCase in
        DefaultTransactionsUseCase(
            zilliqaService: self.zilliqaService(),
            securePersistence: self.securePersistence(),
            preferences: self.preferences()
        )
    }

    /// Factory for the composite `OnboardingUseCase`.
    lazy var onboardingUseCase: Factory<OnboardingUseCase> = _register { [unowned self] () -> OnboardingUseCase in
        DefaultOnboardingUseCase(
            zilliqaService: self.zilliqaService(),
            preferences: self.preferences(),
            securePersistence: self.securePersistence()
        )
    }

    /// Factory for the composite `PincodeUseCase`.
    lazy var pincodeUseCase: Factory<PincodeUseCase> = _register { [unowned self] () -> PincodeUseCase in
        DefaultPincodeUseCase(
            preferences: self.preferences(),
            securePersistence: self.securePersistence()
        )
    }

    // MARK: - Narrow use cases (bind to the same composite instances)

    /// Factory returning the current `WalletUseCase` narrowed to `CreateWalletUseCase`.
    lazy var createWalletUseCase: Factory<CreateWalletUseCase> = _register { [unowned self] () -> CreateWalletUseCase in
        self.walletUseCase()
    }

    /// Factory returning the current `WalletUseCase` narrowed to `RestoreWalletUseCase`.
    lazy var restoreWalletUseCase: Factory<RestoreWalletUseCase> = _register { [unowned self] () -> RestoreWalletUseCase in
        self.walletUseCase()
    }

    /// Factory returning the current `WalletUseCase` narrowed to `WalletStorageUseCase`.
    lazy var walletStorageUseCase: Factory<WalletStorageUseCase> = _register { [unowned self] () -> WalletStorageUseCase in
        self.walletUseCase()
    }

    /// Factory returning the current `WalletUseCase` narrowed to
    /// `VerifyEncryptionPasswordUseCase`.
    lazy var verifyEncryptionPasswordUseCase: Factory<VerifyEncryptionPasswordUseCase> = _register { [unowned self] () -> VerifyEncryptionPasswordUseCase in
        self.walletUseCase()
    }

    /// Factory returning the current `WalletUseCase` narrowed to `ExtractKeyPairUseCase`.
    lazy var extractKeyPairUseCase: Factory<ExtractKeyPairUseCase> = _register { [unowned self] () -> ExtractKeyPairUseCase in
        self.walletUseCase()
    }

    /// Factory returning the current `TransactionsUseCase` narrowed to `BalanceCacheUseCase`.
    lazy var balanceCacheUseCase: Factory<BalanceCacheUseCase> = _register { [unowned self] () -> BalanceCacheUseCase in
        self.transactionsUseCase()
    }

    /// Factory returning the current `TransactionsUseCase` narrowed to `GasPriceUseCase`.
    lazy var gasPriceUseCase: Factory<GasPriceUseCase> = _register { [unowned self] () -> GasPriceUseCase in
        self.transactionsUseCase()
    }

    /// Factory returning the current `TransactionsUseCase` narrowed to `FetchBalanceUseCase`.
    lazy var fetchBalanceUseCase: Factory<FetchBalanceUseCase> = _register { [unowned self] () -> FetchBalanceUseCase in
        self.transactionsUseCase()
    }

    /// Factory returning the current `TransactionsUseCase` narrowed to `SendTransactionUseCase`.
    lazy var sendTransactionUseCase: Factory<SendTransactionUseCase> = _register { [unowned self] () -> SendTransactionUseCase in
        self.transactionsUseCase()
    }

    /// Factory returning the current `TransactionsUseCase` narrowed to `TransactionReceiptUseCase`.
    lazy var transactionReceiptUseCase: Factory<TransactionReceiptUseCase> = _register { [unowned self] () -> TransactionReceiptUseCase in
        self.transactionsUseCase()
    }

    // MARK: - Provider (retained for legacy `UseCaseProvider` call sites)

    /// Factory for the composite `UseCaseProvider` used by older call sites that
    /// want to spawn fresh use cases. New code should resolve individual use cases
    /// directly from `Container.shared`.
    lazy var useCaseProvider: Factory<UseCaseProvider> = _register { [unowned self] () -> UseCaseProvider in
        DefaultUseCaseProvider(
            zilliqaService: self.zilliqaService(),
            preferences: self.preferences(),
            securePersistence: self.securePersistence()
        )
    }

    // MARK: - Reset

    /// Resets every registered dependency back to its original closure. Tests that
    /// register multiple dependencies can call this once in `tearDown` instead of
    /// resetting each one individually.
    func reset() {
        _allResettables.forEach { $0.reset() }
    }

    /// Resettables register themselves here on first access so `reset()` can find
    /// them without reflection.
    private var _allResettables: [Resettable] = []

    /// Helper used by the property initializers above to both construct a `Factory`
    /// and register it with the container so the bulk `reset()` can find it.
    private func _register<T>(_ factory: @escaping () -> T) -> Factory<T> {
        let f = Factory(factory)
        _allResettables.append(f)
        return f
    }
}

// MARK: - Resettable

/// Type-erased handle that `Container.reset()` uses to restore every registered
/// dependency in bulk.
private protocol Resettable: AnyObject {

    /// Restores the factory to its originally-registered closure.
    func reset()
}

extension Factory: Resettable {}
