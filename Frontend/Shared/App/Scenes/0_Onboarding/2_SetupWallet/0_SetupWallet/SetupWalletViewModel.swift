//
//  SetupWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation

enum SetupWalletNavigationStep {
    case userIntendsToGenerateNewWallet
    case userIntendsToRestoreExistingWallet
}

protocol SetupWalletViewModel: ObservableObject {
    func generateNewWallet()
    func restoreExistingWallet()
}

extension SetupWalletViewModel {
    typealias Navigator = NavigationStepper<SetupWalletNavigationStep>
}
