//
//  RestoreWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

final class RestoreWalletCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<RestoreWalletCoordinator>(initial: \RestoreWalletCoordinator.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var restore = makeRestore
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        EnsurePrivacyScreen()
    }
    
    
    @ViewBuilder
    func makeRestore() -> some View {
        RestoreWalletScreen()
    }
}

