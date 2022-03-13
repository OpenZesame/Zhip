//
//  SettingsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import ZhipEngine
import Stinsen
import Styleguide
import Screen

enum SettingsCoordinatorNavigationStep {
    case userDeletedWallet
}

final class SettingsCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<SettingsCoordinatorNavigationStep>
    
    let stack = NavigationStack<SettingsCoordinator>(initial: \.start)
    @Root var start = makeStart
    @Route(.push) var unlockApp = makeUnlockApp
    @Route(.push) var setPIN = makeSetupPINCode
    @Route(.push) var backUpWallet = makeBackUpWallet
    @Route(.push) var termsOfService = makeTermsOfService
    
    private lazy var settingsNavigator = SettingsViewModel.Navigator()
    private lazy var unlockAppWithPINNavigator = UnlockAppWithPINViewModel.Navigator()
    private lazy var setupPinCoordinatorNavigator = SetupPINCodeCoordinator.Navigator()
    private lazy var backUpWalletCoordinatorNavigator = BackUpWalletCoordinator.Navigator()
    private lazy var termsOfServiceNavigator = TermsOfServiceViewModel.Navigator()
    
    private unowned let navigator: Navigator
    private let useCaseProvider: UseCaseProvider
    
    init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
}


// MARK: - NavigationCoordinatable
// MARK: -
extension SettingsCoordinator {
    
    @ViewBuilder
    func customize(_ view: AnyView) -> some View {
        ForceFullScreen { [unowned self] in
            view
                .onReceive(settingsNavigator) { userDid in
                    switch userDid {
                    case .removeWallet:
                        toRemoveWallet()
                    case .removePincode:
                        toUnlockAppWithPINToRemoveIt()
                    case .setPincode:
                        toSetPIN()
                    case .backupWallet:
                        toBackUpWallet()
                    case .readTermsOfService:
                        toTermsOfService()
                        #if DEBUG
                    case .debugOnlyNukeApp:
                        debugOnlyNukeWholeApp()
                        #endif // DEBUG
                    default:
                        fatalError("unhandled")
                    }
                }
                .onReceive(setupPinCoordinatorNavigator) { userDid in
                    switch userDid {
                    case .finishedPINSetup:
                        popLast {
                            print("SettingsCoordinator:popLast: SetupPINCoordinator should deinit")
                        }
                    }
                }
                .onReceive(unlockAppWithPINNavigator) { userDid in
                    switch userDid {
                    case .enteredCorrectPINCode(let intent):
                        popLast {
                            print("SettingsCoordinator:popLast UnlockAppWithPinViewModel should deinit")
                            userAuthenticated(to: intent)
                        }
                    case .cancel:
                        popLast {
                            print("SettingsCoordinator:popLast UnlockAppWithPinViewModel should deinit")
                        }
                    }
                }
                .onReceive(backUpWalletCoordinatorNavigator) { userDid in
                    switch userDid {
                    case .userDidBackUpWallet:
                        popLast {
                            print("SettingsCoordinator:popLast - userDidBackUpWallet - BackUpWalletCoordinator should deinit")
                        }
                    }
                }
                .onReceive(termsOfServiceNavigator) { userDid in
                    switch userDid {
                    case .userDidAcceptTerms:
                        popLast {
                            print("SettingsCoordinator:popLast - userDidBackUpWallet - BackUpWalletCoordinator should deinit")
                        }
                    }
                }
        }
    }
    
}

// MARK: - Routing
// MARK: -
extension SettingsCoordinator {
    func toUnlockAppWithPINToRemoveIt() {
        route(to: \.unlockApp, UnlockAppWithPINViewModel.UserIntent.enterToRemovePIN)
    }
    
    func toUnlockAppWithPINToRemoveWallet() {
        route(to: \.unlockApp, UnlockAppWithPINViewModel.UserIntent.enterToRemoveWallet)
    }
    
    func toSetPIN() {
        route(to: \.setPIN)
    }
    
    func toBackUpWallet() {
        route(to: \.backUpWallet)
    }
    
    func toTermsOfService() {
        route(to: \.termsOfService)
    }
    
    func toRemoveWallet() {
        if useCaseProvider.makePINCodeUseCase().hasConfiguredPincode {
            toUnlockAppWithPINToRemoveWallet()
        } else {
            useCaseProvider.nuke()
            navigator.step(.userDeletedWallet)
        }
    }
    #if DEBUG
    func debugOnlyNukeWholeApp() {
        useCaseProvider.nuke(resetHasAppRunBeforeFlag: true, resetHasAcceptedTermsOfService: true)
        navigator.step(.userDeletedWallet)
    }
    #endif // DEBUG
    
    func userAuthenticated(to intent: UnlockAppWithPINViewModel.UserIntent) {
        switch intent {
        case .enterToUnlockApp:
            break
        case .enterToRemoveWallet:
            useCaseProvider.nuke()
            navigator.step(.userDeletedWallet)
        case .enterToRemovePIN:
            useCaseProvider.makePINCodeUseCase().deletePincode()
        }
    }
}

// MARK: - Factory
// MARK: -
extension SettingsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        let viewModel = SettingsViewModel(
            navigator: settingsNavigator,
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            pincodeUseCase: useCaseProvider.makePINCodeUseCase()
        )
        SettingsScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeUnlockApp(intent: UnlockAppWithPINViewModel.UserIntent) -> some View {
        let viewModel = UnlockAppWithPINViewModel(
            userIntent: intent,
            navigator: unlockAppWithPINNavigator,
            useCase: useCaseProvider.makePINCodeUseCase()
        )
        UnlockAppWithPINScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeTermsOfService() -> some View {
        let viewModel = TermsOfServiceViewModel(
            mode: .userInitiatedFromSettings,
            navigator: termsOfServiceNavigator,
            useCase: useCaseProvider.makeOnboardingUseCase() // TODO: clean up, should not need to pass this in.
        )
        
        TermsOfServiceScreen(viewModel: viewModel)
    }
    

    func makeSetupPINCode() -> NavigationViewCoordinator<SetupPINCodeCoordinator> {
        
        let setupPINCodeCoordinator = SetupPINCodeCoordinator(
            navigator: setupPinCoordinatorNavigator,
            useCase: useCaseProvider.makePINCodeUseCase()
        )
        
        return NavigationViewCoordinator(setupPINCodeCoordinator)
    }
    
    func makeBackUpWallet() -> NavigationViewCoordinator<BackUpWalletCoordinator> {
        guard let wallet = useCaseProvider.makeWalletUseCase().walletSubject.value else {
            fatalError("No wallet?")
        }
        let backUpWalletCoordinator = BackUpWalletCoordinator(
            mode: .userInitiatedFromSettings,
            navigator: backUpWalletCoordinatorNavigator,
            useCaseProvider: useCaseProvider,
            wallet: wallet
        )
        
        return NavigationViewCoordinator(backUpWalletCoordinator)
    }
    
 
}
