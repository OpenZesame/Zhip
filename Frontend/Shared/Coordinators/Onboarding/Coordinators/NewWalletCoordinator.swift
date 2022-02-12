//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

final class NewWalletCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<NewWalletCoordinator>(initial: \NewWalletCoordinator.ensurePrivacy)
    
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
