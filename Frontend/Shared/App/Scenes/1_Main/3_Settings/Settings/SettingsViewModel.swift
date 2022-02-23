//
//  SettingsViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation

enum SettingsNavigationStep {
    case deleteWallet
}

protocol SettingsViewModel: ObservableObject {
    var isAskingForDeleteWalletConfirmation: Bool { get set }
    func askForDeleteWalletConfirmation()
    func confirmWalletDeletion()
}

extension SettingsViewModel {
    typealias Navigator = NavigationStepper<SettingsNavigationStep>
}
