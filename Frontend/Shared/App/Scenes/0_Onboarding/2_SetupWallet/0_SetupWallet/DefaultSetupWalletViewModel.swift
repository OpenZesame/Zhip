//
//  DefaultSetupWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

final class DefaultSetupWalletViewModel: SetupWalletViewModel {
    private unowned let navigator: Navigator
    
    init(
        navigator: Navigator
    ) {
        self.navigator = navigator
    }
    
    func generateNewWallet() {
        navigator.step(.userIntendsToGenerateNewWallet)
    }
    
    func restoreExistingWallet() {
        navigator.step(.userIntendsToRestoreExistingWallet)
    }
}
