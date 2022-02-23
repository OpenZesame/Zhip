//
//  RestoreWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

final class RestoreWalletCoordinator: NavigationCoordinatable {
    
    let stack = NavigationStack<RestoreWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var restore = makeRestore
    
    private lazy var restoreWalletNavigator = RestoreWalletViewModel.Navigator()
    private lazy var ensurePrivacyNavigator = EnsurePrivacyViewModel.Navigator()
    
    init() {}
  
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
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}

// MARK: - Factory
// MARK: -
extension RestoreWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        
        let viewModel = DefaultEnsurePrivacyViewModel(
            navigator: ensurePrivacyNavigator
        )
        
        EnsurePrivacyScreen(viewModel: viewModel)
    }
    
    
    @ViewBuilder
    func makeRestore() -> some View {
        
        let viewModel = DefaultRestoreWalletViewModel(
            navigator: restoreWalletNavigator
        )
        
        RestoreWalletScreen(viewModel: viewModel)
    }
}

