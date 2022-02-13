//
//  RestoreWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol RestoreWalletCoordinator: RestoreOrGenerateNewWalletCoordinator {
    
}

final class DefaultRestoreWalletCoordinator: RestoreWalletCoordinator, NavigationCoordinatable {
    
    let stack = NavigationStack<DefaultRestoreWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var restore = makeRestore
    
    init() {}
    deinit {
        print("deinit DefaultRestoreWalletCoordinator")
    }
}

extension DefaultRestoreWalletCoordinator {
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

extension DefaultRestoreWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        let viewModel = DefaultEnsurePrivacyViewModel<DefaultRestoreWalletCoordinator>(coordinator: self)
        EnsurePrivacyScreen(viewModel: viewModel)
    }
    
    
    @ViewBuilder
    func makeRestore() -> some View {
        let viewModel = DefaultRestoreWalletViewModel(coordinator: self)
        RestoreWalletScreen(viewModel: viewModel)
    }
}

