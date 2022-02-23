//
//  BackupWalletViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-19.
//

import Foundation

enum BackupWalletNavigationStep {
    case finishedBackingUpWallet
    case revealKeystore
    case revealPrivateKey
}

protocol BackupWalletViewModel: ObservableObject {
    var userHasConfirmedBackingUpWallet: Bool { get set }
    var isFinished: Bool { get set }
    func `continue`()
    func copyKeystoreToPasteboard()
    func revealKeystore()
    func revealPrivateKey()
    var isPresentingDidCopyKeystoreAlert: Bool { get set }
}

extension BackupWalletViewModel {
    typealias Navigator = NavigationStepper<BackupWalletNavigationStep>
}
