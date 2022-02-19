//
//  SetupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

// MARK: - SetupWalletCoordinator
// MARK: -
protocol SetupWalletCoordinator: AnyObject {
    func generateNewWallet()
    func restoreExistingWallet()
}

// MARK: - DefaultSetupWalletCoordinator
// MARK: -
final class DefaultSetupWalletCoordinator: NavigationCoordinatable, SetupWalletCoordinator {
    
    let stack = NavigationStack<DefaultSetupWalletCoordinator>(initial: \.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    private let useCaseProvider: UseCaseProvider
    
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
}

// MARK: - SetupWalletC. Conformance
// MARK: -
extension DefaultSetupWalletCoordinator {
    func generateNewWallet() {
        toGenerateNewWallet()
    }
    
    func restoreExistingWallet() {
        toRestoreExistingWallet()
    }
 
}

// MARK: - Routing
// MARK: -
extension DefaultSetupWalletCoordinator {
    func toGenerateNewWallet() {
        route(to: \.newWallet)
        
    }
    
    func toRestoreExistingWallet() {
        route(to: \.restoreWallet)
    }
}

// MARK: - Factory
// MARK: -
extension DefaultSetupWalletCoordinator {
    @ViewBuilder
    func makeSetupWallet() -> some View {
        let viewModel = DefaultSetupWalletViewModel(coordinator: self)
        SetupWalletScreen(viewModel: viewModel)
    }
    
    func makeNewWallet() -> NavigationViewCoordinator<DefaultNewWalletCoordinator> {
        .init(DefaultNewWalletCoordinator(useCaseProvider: useCaseProvider))
    }
    
    func makeRestoreWallet() -> NavigationViewCoordinator<DefaultRestoreWalletCoordinator> {
        .init(DefaultRestoreWalletCoordinator())
    }
}
