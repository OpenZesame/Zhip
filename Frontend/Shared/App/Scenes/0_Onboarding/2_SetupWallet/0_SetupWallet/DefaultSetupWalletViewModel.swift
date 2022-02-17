//
//  DefaultSetupWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

final class DefaultSetupWalletViewModel: SetupWalletViewModel {
    private unowned let coordinator: SetupWalletCoordinator
    
    init(
        coordinator: SetupWalletCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    func generateNewWallet() {
        coordinator.generateNewWallet()
    }
    
    func restoreExistingWallet() {
        coordinator.restoreExistingWallet()
    }
}
