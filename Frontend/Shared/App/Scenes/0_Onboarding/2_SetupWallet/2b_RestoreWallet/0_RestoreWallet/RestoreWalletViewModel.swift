//
//  RestoreWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import ZhipEngine

enum RestoreWalletNavigationStep {
    case restoreWallet(Wallet)
}

protocol RestoreWalletViewModel: ObservableObject {}
extension RestoreWalletViewModel {
    typealias Navigator = NavigationStepper<RestoreWalletNavigationStep>
}

final class DefaultRestoreWalletViewModel: RestoreWalletViewModel {
    private unowned let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
    
    deinit {
        print("☑️ DefaultRestoreWalletViewModel deinit")
    }
}
