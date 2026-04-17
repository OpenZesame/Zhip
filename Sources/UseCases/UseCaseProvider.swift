// MIT License — Copyright (c) 2018-2026 Open Zesame

import Zesame

protocol UseCaseProvider {
    func makeOnboardingUseCase() -> OnboardingUseCase
    func makeWalletUseCase() -> WalletUseCase
    func makeTransactionsUseCase() -> TransactionsUseCase
    func makePincodeUseCase() -> PincodeUseCase
}
