//
//  RestoreWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

enum RestoreWalletCoordinatorNavigationStep {
    case didRestoreWallet(Wallet)
    case abortBecauseScreenMightBeWatched
}

final class RestoreWalletCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<RestoreWalletCoordinatorNavigationStep>
    
    let stack = NavigationStack<RestoreWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var restore = makeRestore
    
    private lazy var restoreWalletNavigator = RestoreWalletViewModel.Navigator()
    private lazy var ensurePrivacyNavigator = EnsurePrivacyViewModel.Navigator()
    
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    
    init(navigator: Navigator, useCase: WalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
  
    deinit {
        print("✅ RestoreWalletCoordinator DEINIT 💣")
    }
}


// MARK: - NavigationCoordinatable
// MARK: -
extension RestoreWalletCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {

        view
            .onReceive(ensurePrivacyNavigator) { [unowned self] userDid in
                switch userDid {
                case .ensurePrivacy: self.privacyIsEnsured()
                case .thinkScreenMightBeWatched: self.myScreenMightBeWatched()
                }
            }
            .onReceive(restoreWalletNavigator) { [unowned self] userDid in
                switch userDid {
                case .restoreWallet(let wallet):
                    fatalError("impl me")
                case .failedToRestoreWallet(let error):
                    fatalError("fauled to restore wallet, error: \(error)")
                }
                
            }
    }
}

// MARK: - Routing
// MARK: -
extension RestoreWalletCoordinator {
    func privacyIsEnsured() {
        toRestoreWallet()
    }
    
    func toRestoreWallet() {
        route(to: \.restore)
    }
    
    func myScreenMightBeWatched() {
//        dismissCoordinator {
//            print("dismissing \(self)")
//        }
        navigator.step(.abortBecauseScreenMightBeWatched)
    }
}

// MARK: - Factory
// MARK: -
extension RestoreWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        
        let viewModel = EnsurePrivacyViewModel(
            navigator: ensurePrivacyNavigator
        )
        
        EnsurePrivacyScreen(viewModel: viewModel)
    }
    
    
    @ViewBuilder
    func makeRestore() -> some View {
        
        let viewModel = RestoreWalletViewModel(
            navigator: restoreWalletNavigator,
            useCase: useCase
        )
        
        RestoreWalletScreen(viewModel: viewModel)
    }
}

