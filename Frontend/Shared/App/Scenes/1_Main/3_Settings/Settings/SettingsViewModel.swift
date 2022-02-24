//
//  SettingsViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

public enum SettingsNavigationStep {
    case deleteWallet
}

// MARK: - SettingsViewModel
// MARK: -
public final class SettingsViewModel: ObservableObject {
    
    @Published var isAskingForDeleteWalletConfirmation: Bool = false
    
    private unowned let navigator: Navigator
    private let useCase: WalletUseCase
    
    public init(navigator: Navigator, useCase: WalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
}

// MARK: - Public
// MARK: -
public extension SettingsViewModel {
    
    typealias Navigator = NavigationStepper<SettingsNavigationStep>
    
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
