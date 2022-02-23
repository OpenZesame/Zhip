//
//  DefaultSettingsViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

// MARK: - DefaultSettingsViewModel
// MARK: -
final class DefaultSettingsViewModel: SettingsViewModel {
    @Published var isAskingForDeleteWalletConfirmation: Bool = false
    
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    
    init(navigator: Navigator, useCase: WalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
}

// MARK: - SettingsViewModel
// MARK: -
extension DefaultSettingsViewModel {
    
    func askForDeleteWalletConfirmation() {
        isAskingForDeleteWalletConfirmation = true
    }

    func confirmWalletDeletion() {
        defer {
            isAskingForDeleteWalletConfirmation = false
        }
        useCase.deleteWallet()
        navigator.step(.deleteWallet)
    }
}
