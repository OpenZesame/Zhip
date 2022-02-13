//
//  SetupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol SetupWalletCoordinator: AnyObject {
    func generateNewWallet()
    func restoreExistingWallet()
}

final class DefaultSetupWalletCoordinator: NavigationCoordinatable, SetupWalletCoordinator {
    let stack = NavigationStack<DefaultSetupWalletCoordinator>(initial: \.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    @ViewBuilder
    func makeSetupWallet() -> some View {
        let viewModel = DefaultSetupWalletViewModel(coordinator: self)
        SetupWalletScreen(viewModel: viewModel)
    }
    
    func makeNewWallet() -> NavigationViewCoordinator<DefaultNewWalletCoordinator> {
        .init(DefaultNewWalletCoordinator())
    }
    
    func makeRestoreWallet() -> NavigationViewCoordinator<DefaultRestoreWalletCoordinator> {
        .init(DefaultRestoreWalletCoordinator())
    }
    
    func generateNewWallet() {
        toGenerateNewWallet()
    }
    
    func restoreExistingWallet() {
        toRestoreExistingWallet()
    }
}

extension DefaultSetupWalletCoordinator {
    func toGenerateNewWallet() {
        fatalError("toGenerateNewWallet")
    }
    
    func toRestoreExistingWallet() {
        fatalError("toRestoreExistingWallet")
    }
}
