//
//  SetupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine
import Combine

enum SetupWalletCoordinatorNavigationStep {
    case finishSettingUpWallet(wallet: Wallet)
}

// MARK: - SetupWalletCoordinator
// MARK: -
final class SetupWalletCoordinator: NavigationCoordinatable {
    typealias Navigator = NavigationStepper<SetupWalletCoordinatorNavigationStep>
    
    let stack = NavigationStack<SetupWalletCoordinator>(initial: \.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    private let setupWalletNavigator = SetupWalletViewModel.Navigator()
    private let newWalletCoordinatorNavigator = NewWalletCoordinator.Navigator()
    
    private unowned let navigator: Navigator
    private let useCaseProvider: UseCaseProvider
    
    init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("✅ SetupWalletCoordinator DEINIT 💣")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension SetupWalletCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(setupWalletNavigator) { [unowned self] userDid in
                switch userDid {
                case .userIntendsToRestoreExistingWallet:
                    toRestoreExistingWallet()
                case .userIntendsToGenerateNewWallet:
                    toGenerateNewWallet()
                }
            }
            .onReceive(newWalletCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .create(let wallet):
                   userFinishedSettingUpNewWallet(wallet)
                case .cancel:
                    fatalError("We should probably propagate the `cancel` event up to this coordinators parent coordinator.")
                }
            }
    }
}

// MARK: - Routing
// MARK: -
extension SetupWalletCoordinator {

    func userFinishedSettingUpNewWallet(_ wallet: Wallet) {
        print("🔮💶 SetupWalletCoordinator:userFinishedSettingUpNewWallet")
        
        // Hmm not happy about this...
        // TODO: find out why we cannot simply dismiss the whole coordinator
        _ = popToRoot { [unowned self] in
            navigator.step(.finishSettingUpWallet(wallet: wallet))
        }
    }
    
    func toGenerateNewWallet() {
        route(to: \.newWallet)
    }
    
    func toRestoreExistingWallet() {
        route(to: \.restoreWallet)
    }
    
    func generateNewWallet() {
        toGenerateNewWallet()
    }
    
    func restoreExistingWallet() {
        toRestoreExistingWallet()
    }
}

// MARK: - Factory
// MARK: -
extension SetupWalletCoordinator {
    
    @ViewBuilder
    func makeSetupWallet() -> some View {
        let viewModel = DefaultSetupWalletViewModel(navigator: setupWalletNavigator)
        SetupWalletScreen(viewModel: viewModel)
    }
    
    func makeNewWallet() -> NavigationViewCoordinator<NewWalletCoordinator> {
        let newWalletCoordinator = NewWalletCoordinator(
            navigator: newWalletCoordinatorNavigator,
            useCaseProvider: useCaseProvider
        )
        
        return NavigationViewCoordinator(
            newWalletCoordinator
        )
    }
    
    func makeRestoreWallet() -> NavigationViewCoordinator<RestoreWalletCoordinator> {
        .init(RestoreWalletCoordinator())
    }
    
}

