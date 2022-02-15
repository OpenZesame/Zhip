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
    func didAcceptTermsOfService()
}

final class DefaultOnboardingCoordinator: OnboardingCoordinator, NavigationCoordinatable {

    // MARK: Injected properties
    private let useCaseProvider: UseCaseProvider
    
    // MARK: Self-init properties
    let stack = NavigationStack(initial: \DefaultOnboardingCoordinator.welcome)
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    
    @Root var welcome = makeWelcome
    @Route(.push) var termsOfService = makeTermsOfService
    
    // Replace navigation stack
    @Root var setupWallet = makeSetupWallet

    // Replace navigation stack
    @Root var setupPINCode = makeSetupPINCode
    
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
    
    func didAcceptTermsOfService() {
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
        
        let viewModel = DefaultTermsOfServiceViewModel(
            coordinator: self,
            useCase: onboardingUseCase
        )
        
        TermsOfServiceScreen(viewModel: viewModel)
    }
    
    func makeSetupWallet() -> NavigationViewCoordinator<DefaultSetupWalletCoordinator> {
        NavigationViewCoordinator(DefaultSetupWalletCoordinator(useCaseProvider: useCaseProvider))
    }
    
    func makeSetupPINCode(wallet: Wallet) -> DefaultSetupPINCodeCoordinator {
        DefaultSetupPINCodeCoordinator()
    }
    
    @ViewBuilder
    func makeWelcome() -> some View {
        WelcomeScreen(viewModel: DefaultWelcomeViewModel(coordinator: self))
    }
}
