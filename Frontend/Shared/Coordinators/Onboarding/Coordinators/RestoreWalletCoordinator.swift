//
//  RestoreWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol RestoreWalletCoordinator: AnyObject {
    
}

final class DefaultRestoreWalletCoordinator: RestoreWalletCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultRestoreWalletCoordinator>(initial: \.ensurePrivacy)
    
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

