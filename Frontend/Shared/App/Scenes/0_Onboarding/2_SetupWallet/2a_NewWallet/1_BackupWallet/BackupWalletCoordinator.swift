//
//  BackupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import Stinsen

protocol BackupWalletCoordinator: AnyObject {
    
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
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("deinit DefaultBackupWalletCoordinator")
    }
    
}

extension DefaultBackupWalletCoordinator {
    
    @ViewBuilder
    func makeBackupWallet() -> some View {
        let viewModel = DefaultBackupWalletViewModel(coordinator: self)
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
