//
//  SetupWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

// MARK: - SetupWalletNavigationStep
// MARK: -
public enum SetupWalletNavigationStep {
    case userIntendsToGenerateNewWallet
    case userIntendsToRestoreExistingWallet
}

// MARK: - SetupWalletViewModel
// MARK: -
public final class SetupWalletViewModel: ObservableObject {
    
    private unowned let navigator: Navigator
    
    public init(
        navigator: Navigator
    ) {
        self.navigator = navigator
    }
    
    deinit {
        print("☑️ SetupWalletViewModel deinit")
    }
}

// MARK: - Public
// MARK: -
public extension SetupWalletViewModel {
    
    typealias Navigator = NavigationStepper<SetupWalletNavigationStep>
    
    func generateNewWallet() {
        navigator.step(.userIntendsToGenerateNewWallet)
    }
    
    func restoreExistingWallet() {
        navigator.step(.userIntendsToRestoreExistingWallet)
    }
}
