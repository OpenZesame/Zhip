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
    case finishOnboarding(wallet: Wallet)
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
    private lazy var welcomeNavigator = WelcomeViewModel.Navigator()
    private lazy var termsOfServiceNavigator = TermsOfServiceViewModel.Navigator()
    private lazy var setupWalletCoordinatorNavigator = SetupWalletCoordinator.Navigator()
    private lazy var setupPinCoordinatorNavigator = SetupPINCodeCoordinator.Navigator()

    init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("✅ OnboardingCoordinator DEINIT 💣")
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
            .onReceive(setupWalletCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishSettingUpWallet(let wallet):
                    print("🔮💶 OnboardingCoordinator:userFinishedSettingUpNewWallet")
                    walletUseCase.save(wallet: wallet)
                    toNextStep()
                }
            }
            .onReceive(setupPinCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishedPINSetup:
                    finishedOnboarding()
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
        
        if onboardingUseCase.shouldPromptUserToChosePincode {
            return toSetupPIN()
        }
        
        finishedOnboarding()
    }
    
    func toTermsOfService() {
        root(\.termsOfService)
    }
    
    func toSetupWallet() {
        root(\.setupWallet)
   }
    
    func toSetupPIN() {
        root(\.setupPINCode)
    }
    
    func finishedOnboarding() {
        guard let wallet = walletUseCase.loadWallet() else {
            fatalError("Expected to have setup a wallet by now, but we have none.")
        }
        navigator.step(.finishOnboarding(wallet: wallet))
    }
}

// MARK: - Factory
// MARK: -
private extension OnboardingCoordinator {
    
    @ViewBuilder
    func makeWelcome() -> some View {
        let viewModel = WelcomeViewModel(navigator: welcomeNavigator)
        WelcomeScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeTermsOfService() -> some View {
        
        let viewModel = TermsOfServiceViewModel(
            navigator: termsOfServiceNavigator,
            useCase: onboardingUseCase
        )
        
        TermsOfServiceScreen(viewModel: viewModel)
    }
    
    func makeSetupWallet() -> NavigationViewCoordinator<SetupWalletCoordinator> {
        
        let setupWalletCoordinator = SetupWalletCoordinator(
            navigator: setupWalletCoordinatorNavigator,
            useCaseProvider: useCaseProvider
        )
        
        return NavigationViewCoordinator(setupWalletCoordinator)
    }
    
    func makeSetupPINCode() -> NavigationViewCoordinator<SetupPINCodeCoordinator> {
        
        let setupPINCodeCoordinator = SetupPINCodeCoordinator(
            navigator: setupPinCoordinatorNavigator,
            useCase: useCaseProvider.makePINCodeUseCase()
        )
        
        return NavigationViewCoordinator(setupPINCodeCoordinator)
    }
 
}
