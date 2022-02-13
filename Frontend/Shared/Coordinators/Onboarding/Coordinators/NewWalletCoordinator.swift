//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol RestoreOrGenerateNewWalletCoordinator: AnyObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}

protocol NewWalletCoordinator: RestoreOrGenerateNewWalletCoordinator {}

final class DefaultNewWalletCoordinator: NewWalletCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultNewWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var new = makeNew
    
    init() {}
    deinit {
        print("deinit DefaultNewWalletCoordinator")
    }

}

extension DefaultNewWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        let viewModel = DefaultEnsurePrivacyViewModel<DefaultNewWalletCoordinator>(coordinator: self)
        EnsurePrivacyScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeNew() -> some View {
        NewWalletScreen()
    }
    
    func privacyIsEnsured() {
        toNewWallet()
    }
    
    func toNewWallet() {
        route(to: \.new)
    }
    
    func myScreenMightBeWatched() {
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}
