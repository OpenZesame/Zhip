// MIT License — Copyright (c) 2018-2026 Open Zesame

import Zesame

/// Legacy service-locator used by coordinators that predate `Container.shared`.
///
/// New code should resolve use cases directly from `Container.shared` — see
/// `Sources/Application/DI/Container.swift`. This protocol is retained so the
/// existing coordinator constructor shape (`init(useCaseProvider:)`) keeps
/// compiling during the gradual DI migration.
protocol UseCaseProvider {

    /// Returns a fresh `OnboardingUseCase`.
    func makeOnboardingUseCase() -> OnboardingUseCase

    /// Returns a fresh `WalletUseCase`.
    func makeWalletUseCase() -> WalletUseCase

    /// Returns a fresh `TransactionsUseCase`.
    func makeTransactionsUseCase() -> TransactionsUseCase

    /// Returns a fresh `PincodeUseCase`.
    func makePincodeUseCase() -> PincodeUseCase
}
