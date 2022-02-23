//
//  RestoreWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import Foundation
import ZhipEngine

enum RestorationMethod {
    case importKeystore
    case importPrivateKey
}

enum RestoreWalletNavigationStep {
    case restoreWallet(Wallet)
}

protocol RestoreWalletViewModel: ObservableObject {
    var restorationMethod: RestorationMethod { get set }
    
    var restoreWalletUsingKeystoreViewModel: DefaultRestoreWalletUsingKeystoreViewModel { get }
    var restoreWalletUsingPrivateKeyViewModel: DefaultRestoreWalletUsingPrivateKeyViewModel { get }
}

extension RestoreWalletViewModel {
    typealias Navigator = NavigationStepper<RestoreWalletNavigationStep>
}


