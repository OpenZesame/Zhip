//
//  OnboardingCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

import ZhipEngine
import Stinsen



protocol OnboardingCoordinator: AnyObject {
    func didStart()
}

final class DefaultOnboardingCoordinator: NavigationCoordinatable, OnboardingCoordinator {

    // MARK: Injected properties
    private let useCaseProvider: UseCaseProvider
    
    // MARK: Self-init properties
    let stack = NavigationStack(initial: \DefaultOnboardingCoordinator.welcome)
    
    @Root var welcome = makeWelcome
    @Route(.push) var termsOfService = makeTermsOfService
    
    // Replace navigation stack
    @Root var setupWallet = makeSetupWallet

    // Replace navigation stack
    @Root var setupPINCode = makeSetupPINCode
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("Deinit OnboardingCoordinator")
    }
}

// MARK: - OnboardingCoordinator
// MARK: -
extension DefaultOnboardingCoordinator {
    
    func didStart() {
        toNextStep()
    }
}

// MARK: - Private
// MARK: -
private extension DefaultOnboardingCoordinator {
    
    func toNextStep() {
        if !onboardingUseCase.hasAcceptedTermsOfService {
            return toTermsOfService()
        }
        
        if !walletUseCase.hasConfiguredWallet {
            return toSetupWallet()
        }
    }
    
    func toSetupWallet() {
        self.root(\.setupWallet)
   }
    
    func toTermsOfService() {
        self.route(to: \.termsOfService)
    }
}

// MARK: - Factory
// MARK: -
private extension DefaultOnboardingCoordinator {
    
    @ViewBuilder
    func makeTermsOfService() -> some View {
        TermsOfServiceScreen()
    }
    
    func makeSetupWallet() -> NavigationViewCoordinator<SetupWalletCoordinator> {
        NavigationViewCoordinator(SetupWalletCoordinator())
    }
    
    func makeSetupPINCode(wallet: Wallet) -> SetupPINCodeCoordinator {
        SetupPINCodeCoordinator()
    }
    
    @ViewBuilder
    func makeWelcome() -> some View {
        WelcomeScreen(viewModel: DefaultWelcomeViewModel(coordinator: self))
    }
}
