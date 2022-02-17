//
//  DefaultEnsurePrivacyViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

final class DefaultEnsurePrivacyViewModel<Coordinator: RestoreOrGenerateNewWalletCoordinator>: EnsurePrivacyViewModel {
    
    private unowned let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - EnsurePrivacyViewModel
// MARK: -
extension DefaultEnsurePrivacyViewModel {
    func privacyIsEnsured() {
        coordinator.privacyIsEnsured()
    }
    
    func myScreenMightBeWatched() {
        coordinator.myScreenMightBeWatched()
    }
}
