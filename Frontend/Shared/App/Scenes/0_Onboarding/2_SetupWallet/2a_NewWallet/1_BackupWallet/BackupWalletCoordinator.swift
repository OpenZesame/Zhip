//
//  BackupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import ZhipEngine
import Stinsen

// MARK: - BackupWalletCoordinator
// MARK: -
protocol BackupWalletCoordinator: AnyObject {
    
    func doneBackingUpWallet()
    func revealKeystore()
    func revealPrivateKey()
    func doneBackingUpKeystore()
    func doneBackingUpPrivateKey()
}

// MARK: - DefaultBackupWalletCoordinator
// MARK: -
final class DefaultBackupWalletCoordinator: BackupWalletCoordinator, NavigationCoordinatable {
    
    let stack = NavigationStack<DefaultBackupWalletCoordinator>(initial: \.backupWallet)
    
    @Root var backupWallet = makeBackupWallet
    @Route(.push) var revealKeystoreRoute = makeRevealKeystore
    @Route(.push) var revealPrivateKeyRoute = makeBackUpRevealedKeyPair
    
    private let useCaseProvider: UseCaseProvider
    private let wallet: Wallet
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
   
    private let didBackUpWallet: () -> Void
    
    init(useCaseProvider: UseCaseProvider, wallet: Wallet, didBackUpWallet: @escaping () -> Void) {
        self.useCaseProvider = useCaseProvider
        self.wallet = wallet
        self.didBackUpWallet = didBackUpWallet
    }
    
    deinit {
        print("\(self) deinit")
    }
    
}

// MARK: - Factory
// MARK: -
extension DefaultBackupWalletCoordinator {
    
    @ViewBuilder
    func makeBackupWallet() -> some View {
        let viewModel = DefaultBackupWalletViewModel(coordinator: self, wallet: wallet)
        BackupWalletScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeRevealKeystore() -> some View {
        let viewModel = DefaultBackUpKeystoreViewModel(coordinator: self, wallet: wallet)
        BackUpKeystoreScreen(viewModel: viewModel)
    }
    
    func makeBackUpRevealedKeyPair() -> NavigationViewCoordinator<DefaultBackUpKeyPairCoordinator> {
        NavigationViewCoordinator(
            DefaultBackUpKeyPairCoordinator(
                useCase: walletUseCase,
                wallet: wallet
            )
        )
    }
}

// MARK: - BackupWalletC. Conf.
// MARK: -
extension DefaultBackupWalletCoordinator {
    func revealKeystore() {
        toRevealKeystore()
    }
    func revealPrivateKey() {
        toBackUpRevealedKeyPair()
    }
    
    func doneBackingUpWallet() {
        didBackUpWallet()
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
}
   
// MARK: - Routing
// MARK: -
extension DefaultBackupWalletCoordinator {
    func toRevealKeystore() {
        route(to: \.revealKeystoreRoute)
    }
    
    func toBackUpRevealedKeyPair() {
        route(to: \.revealPrivateKeyRoute)
    }
    
}
