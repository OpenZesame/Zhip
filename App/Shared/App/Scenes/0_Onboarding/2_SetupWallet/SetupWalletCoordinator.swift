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
    case finishSettingUpWallet
}

// MARK: - SetupWalletCoordinator
// MARK: -
final class SetupWalletCoordinator: NavigationCoordinatable {
    typealias Navigator = NavigationStepper<SetupWalletCoordinatorNavigationStep>
    
    let stack = NavigationStack<SetupWalletCoordinator>(initial: \.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    private lazy var setupWalletNavigator = SetupWalletViewModel.Navigator()

    private lazy var newWalletCoordinatorNavigator = NewWalletCoordinator.Navigator()
    private lazy var restoreWalletCoordinatorNavigator = RestoreWalletCoordinator.Navigator()
    
    private unowned let navigator: Navigator
    private let useCaseProvider: UseCaseProvider
    private lazy var useCase: WalletUseCase = useCaseProvider.makeWalletUseCase()
    
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
                case .abortBecauseScreenMightBeWatched:
                    abortedBecauseScreenMightBeWatched()
                case .cancel:
                    fatalError("We should probably propagate the `cancel` event up to this coordinators parent coordinator.")
                }
            }
            .onReceive(restoreWalletCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .didRestoreWallet(let wallet):
                    userFinishedSettingUpNewWallet(wallet)
                case .abortBecauseScreenMightBeWatched:
                    abortedBecauseScreenMightBeWatched()
                }
            }
    }
}

// MARK: - Routing
// MARK: -
extension SetupWalletCoordinator {

    func userFinishedSettingUpNewWallet(_ wallet: Wallet) {
        useCase.save(wallet: wallet)
        
        // Hmm not happy about this...
        // TODO: find out why we cannot simply dismiss the whole coordinator
        _ = popToRoot { [unowned self] in
            navigator.step(.finishSettingUpWallet)
        }
    }
    
    func abortedBecauseScreenMightBeWatched() {
        popLast {
            print("abortedBecauseScreenMightBeWatched: should have popped EnsurePrivacyScreen")
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
        let viewModel = SetupWalletViewModel(navigator: setupWalletNavigator)
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
        
        let restoreWalletCoordinator = RestoreWalletCoordinator(
            navigator: restoreWalletCoordinatorNavigator,
            useCase: useCase
        )
        
        return NavigationViewCoordinator(
            restoreWalletCoordinator
        )
    }
    
}

