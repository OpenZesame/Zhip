//
//  SettingsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import ZhipEngine
import Stinsen

enum SettingsCoordinatorNavigationStep {
    case userDeletedWallet
}

final class SettingsCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<SettingsCoordinatorNavigationStep>
    
    let stack = NavigationStack<SettingsCoordinator>(initial: \.start)
    @Root var start = makeStart
    @Route(.push) var unlockApp = makeUnlockApp
    @Route(.push) var setPIN = makeSetupPINCode
    
    private lazy var settingsNavigator = SettingsViewModel.Navigator()
    private lazy var unlockAppWithPINNavigator = UnlockAppWithPINViewModel.Navigator()
    private lazy var setupPinCoordinatorNavigator = SetupPINCodeCoordinator.Navigator()
    
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
    
    func toRemoveWallet() {
        if useCaseProvider.makePINCodeUseCase().hasConfiguredPincode {
            toUnlockAppWithPINToRemoveWallet()
        } else {
            useCaseProvider.nuke()
            navigator.step(.userDeletedWallet)
        }
    }
    
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

    func makeSetupPINCode() -> NavigationViewCoordinator<SetupPINCodeCoordinator> {
        
        let setupPINCodeCoordinator = SetupPINCodeCoordinator(
            navigator: setupPinCoordinatorNavigator,
            useCase: useCaseProvider.makePINCodeUseCase()
        )
        
        return NavigationViewCoordinator(setupPINCodeCoordinator)
    }
 
}
