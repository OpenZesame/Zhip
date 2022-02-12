//
//  SetupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

final class SetupWalletCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<SetupWalletCoordinator>(initial: \SetupWalletCoordinator.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    @ViewBuilder
    func makeSetupWallet() -> some View {
        SetupWalletScreen()
    }
    
    func makeNewWallet() -> NavigationViewCoordinator<NewWalletCoordinator> {
        .init(NewWalletCoordinator())
    }
    
    func makeRestoreWallet() -> NavigationViewCoordinator<RestoreWalletCoordinator> {
        .init(RestoreWalletCoordinator())
    }
    
}
