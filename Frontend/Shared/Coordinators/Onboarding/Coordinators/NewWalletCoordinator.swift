//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol NewWalletCoordinator: AnyObject {}

final class DefaultNewWalletCoordinator: NewWalletCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultNewWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var new = makeNew
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        EnsurePrivacyScreen()
    }
    
    @ViewBuilder
    func makeNew() -> some View {
        NewWalletScreen()
    }
}
