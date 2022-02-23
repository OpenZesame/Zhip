//
//  OnboardingCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

import ZhipEngine
import Stinsen

enum OnboardingCoordinatorNavigationStep {
    case finishOnboarding
}

// MARK: - OnboardingCoordinator
// MARK: -
final class OnboardingCoordinator: NavigationCoordinatable {
    typealias Navigator = NavigationStepper<OnboardingCoordinatorNavigationStep>

    // MARK: - Injected properties
    // MARK: -
    private let useCaseProvider: UseCaseProvider
    
    // MARK: - Self-init properties
    // MARK: -
    let stack = NavigationStack(initial: \OnboardingCoordinator.welcome)
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    
    @Root var welcome = makeWelcome
    
    // Actually we'd prefer `@Route(.push)`, but when replacing TermsOfService
    // with next screen we got a pop animation, which we don't want.
    @Root var termsOfService = makeTermsOfService
    
    // Replace navigation stack
    @Root var setupWallet = makeSetupWallet

    // Replace navigation stack
    @Root var setupPINCode = makeSetupPINCode
    
    private unowned let navigator: Navigator
    private let welcomeNavigator = WelcomeViewModel.Navigator()
    private let termsOfServiceNavigator = TermsOfServiceViewModel.Navigator()
    private let setupWalletNavigator = SetupWalletCoordinator.Navigator()
    private let setupPinNavigator = SetupPINCodeCoordinator.Navigator()
    
    init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("Deinit OnboardingCoordinator")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension OnboardingCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {

        view
            .onReceive(welcomeNavigator)  { [unowned self] userDid in
                switch userDid {
                case .didStart:
                    self.toNextStep()
                }
            }
            .onReceive(termsOfServiceNavigator)  { [unowned self] userDid in
                switch userDid {
                case .userDidAcceptTerms:
                    self.toNextStep()
                }
            }
            .onReceive(setupWalletNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishSettingUpWallet(let wallet):
                    self.walletUseCase.save(wallet: wallet)
                    self.root(\.setupPINCode)
                }
            }
            .onReceive(setupPinNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishedPINSetup:
                    self.navigator.step(.finishOnboarding)
                }
            }
        
    }
}

// MARK: - Private
// MARK: -
private extension OnboardingCoordinator {
    
    func toNextStep() {
        if !onboardingUseCase.hasAcceptedTermsOfService {
            return toTermsOfService()
        }
        
        if !walletUseCase.hasConfiguredWallet {
            return toSetupWallet()
        }
    }
    
    func toSetupWallet() {
        root(\.setupWallet)
   }
    
    func toTermsOfService() {
        root(\.termsOfService)
    }
}

// MARK: - Factory
// MARK: -
private extension OnboardingCoordinator {
    
    @ViewBuilder
    func makeWelcome() -> some View {
        WelcomeScreen(viewModel: DefaultWelcomeViewModel(navigator: welcomeNavigator))
    }
    
    @ViewBuilder
    func makeTermsOfService() -> some View {
        
        let viewModel = DefaultTermsOfServiceViewModel(
            navigator: termsOfServiceNavigator,
            useCase: onboardingUseCase
        )
        
        TermsOfServiceScreen(viewModel: viewModel)
    }
    
    func makeSetupWallet() -> NavigationViewCoordinator<SetupWalletCoordinator> {
        let setupWalletCoordinator = SetupWalletCoordinator(
            useCaseProvider: useCaseProvider,
            navigator: setupWalletNavigator
        )
        
        return NavigationViewCoordinator(setupWalletCoordinator)
    }
    
    func makeSetupPINCode() -> NavigationViewCoordinator<SetupPINCodeCoordinator> {
        .init(SetupPINCodeCoordinator(navigator: setupPinNavigator))
    }
 
}
