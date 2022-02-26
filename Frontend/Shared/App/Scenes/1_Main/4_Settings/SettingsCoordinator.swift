//
//  SettingsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen

enum SettingsCoordinatorNavigationStep {
    case userDeletedWallet
}

final class SettingsCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<SettingsCoordinatorNavigationStep>
    
    let stack = NavigationStack<SettingsCoordinator>(initial: \.start)
    @Root var start = makeStart
    @Route(.push) var removePIN = makeUnlockAppWithPINToRemoveIt
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
                        navigator.step(.userDeletedWallet)
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
                    case .enteredCorrectPINCode: fallthrough
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
        route(to: \.removePIN)
    }
    
    func toSetPIN() {
        route(to: \.setPIN)
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
    func makeUnlockAppWithPINToRemoveIt() -> some View {
        let viewModel = UnlockAppWithPINViewModel(
            mode: .enterToRemovePIN,
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
