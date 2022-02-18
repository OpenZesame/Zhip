//
//  BackupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import ZhipEngine
import Stinsen

protocol BackupWalletCoordinator: AnyObject {
    
    func doneBackingUpWallet()
    func revealKeystore()
    func revealPrivateKey()
    func doneBackingUpKeystore()
    func doneBackingUpPrivateKey()
}

final class DefaultBackupWalletCoordinator: BackupWalletCoordinator, NavigationCoordinatable {
    
    let stack = NavigationStack<DefaultBackupWalletCoordinator>(initial: \.backupWallet)
    
    @Root var backupWallet = makeBackupWallet
    @Route(.modal) var revealKeystoreRoute = makeRevealKeystore
    @Route(.modal) var revealPrivateKeyRoute = makeRevealPrivateKey
    
    private let useCaseProvider: UseCaseProvider
    private let wallet: Wallet
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    
    init(useCaseProvider: UseCaseProvider, wallet: Wallet) {
        self.useCaseProvider = useCaseProvider
        self.wallet = wallet
    }
    
    deinit {
        print("deinit DefaultBackupWalletCoordinator")
    }
    
}

extension DefaultBackupWalletCoordinator {
    
    @ViewBuilder
    func makeBackupWallet() -> some View {
        let viewModel = DefaultBackupWalletViewModel(coordinator: self, wallet: wallet)
        BackupWalletScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeRevealKeystore() -> some View {
        let viewModel = DefaultRevealKeystoreViewModel(coordinator: self)
        RevealKeystoreScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeRevealPrivateKey() -> some View {
        let viewModel = DefaultRevealPrivateKeyViewModel(coordinator: self)
        RevealPrivateKeyScreen(viewModel: viewModel)
    }
    
    func revealKeystore() {
        toRevealKeystore()
    }
    func revealPrivateKey() {
        toRevealPrivateKey()
    }
    
    func doneBackingUpWallet() {
        self.dismissCoordinator {
            print("Dismiss BackupWalletCoordinator")
        }
    }
    
    func doneBackingUpKeystore() {
        self.popLast {
            print("Pop keystore")
        }
    }
    
    func doneBackingUpPrivateKey() {
        self.popLast {
            print("Pop private key")
        }
    }
    
    
    func toRevealKeystore() {
        route(to: \.revealKeystoreRoute)
    }
    
    func toRevealPrivateKey() {
        route(to: \.revealPrivateKeyRoute)
    }
    
}
