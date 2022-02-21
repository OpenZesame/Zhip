//
//  OnboardingCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

import ZhipEngine
import Stinsen

// MARK: - OnboardingCoordinator
// MARK: -
protocol OnboardingCoordinator: AnyObject {
    func didStart()
    func didAcceptTermsOfService()
}

// MARK: - DefaultOnboardingCoordinator
// MARK: -
final class DefaultOnboardingCoordinator: OnboardingCoordinator, NavigationCoordinatable {

    // MARK: - Injected properties
    // MARK: -
    private let useCaseProvider: UseCaseProvider
    
    // MARK: - Self-init properties
    // MARK: -
    let stack = NavigationStack(initial: \DefaultOnboardingCoordinator.setupPINCode)
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    
    @Root var welcome = makeWelcome
    @Route(.push) var termsOfService = makeTermsOfService
    
    // Replace navigation stack
    @Root var setupWallet = makeSetupWallet

    // Replace navigation stack
    @Root var setupPINCode = makeSetupPINCode
    
    private let setupWalletNavigator = DefaultSetupWalletCoordinator.Navigator()
    
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("Deinit OnboardingCoordinator")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension DefaultOnboardingCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {

        view.onReceive(setupWalletNavigator.eraseToAnyPublisher(), perform: { [unowned self] userDid in
            switch userDid {
            case .finishSettingUpWallet(let wallet):
                self.walletUseCase.save(wallet: wallet)
                self.root(\.setupPINCode)
            }
        })
        
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
    func makeWelcome() -> some View {
        WelcomeScreen(viewModel: DefaultWelcomeViewModel(coordinator: self))
    }
    
    @ViewBuilder
    func makeTermsOfService() -> some View {
        
        let viewModel = DefaultTermsOfServiceViewModel(
            coordinator: self,
            useCase: onboardingUseCase
        )
        
        TermsOfServiceScreen(viewModel: viewModel)
    }
    
    func makeSetupWallet() -> NavigationViewCoordinator<DefaultSetupWalletCoordinator> {
        let setupWalletCoordinator = DefaultSetupWalletCoordinator(
            useCaseProvider: useCaseProvider,
            navigator: setupWalletNavigator
        )
        
        return NavigationViewCoordinator(setupWalletCoordinator)
    }
    
    func makeSetupPINCode() -> NavigationViewCoordinator<DefaultSetupPINCodeCoordinator> {
        .init(DefaultSetupPINCodeCoordinator())
    }
 
}
