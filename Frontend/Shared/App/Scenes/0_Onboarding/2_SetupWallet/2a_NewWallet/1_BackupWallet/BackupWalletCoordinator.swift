//
//  BackupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-17.
//

import SwiftUI
import ZhipEngine
import Stinsen

enum BackupWalletCoordinatorNavigationStep {
    case userDidBackUpWallet(Wallet)
}

// MARK: - BackupWalletCoordinator
// MARK: -
final class BackupWalletCoordinator: NavigationCoordinatable {
    typealias Navigator = NavigationStepper<BackupWalletCoordinatorNavigationStep>
    
    let stack = NavigationStack<BackupWalletCoordinator>(initial: \.backupWallet)
    
    @Root var backupWallet = makeBackupWallet
    @Route(.push) var revealKeystoreRoute = makeRevealKeystore
    @Route(.push) var revealPrivateKeyRoute = makeBackUpRevealedKeyPair
    
    private let useCaseProvider: UseCaseProvider
    private let wallet: Wallet
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private unowned let navigator: Navigator
    
    private lazy var backUpKeyPairCoordinatorNavigator = BackUpKeyPairCoordinator.Navigator()
    private lazy var backupWalletNavigator = BackupWalletViewModel.Navigator()
    private lazy var backUpKeystoreNavigator = BackUpKeystoreViewModel.Navigator()
    
    init(
        navigator: Navigator,
        useCaseProvider: UseCaseProvider,
        wallet: Wallet
    ) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
        self.wallet = wallet
    }
    
    deinit {
        print("✅ BackupWalletCoordinator DEINIT 💣")
    }
    
}

// MARK: - NavigationCoordinatable
// MARK: -
extension BackupWalletCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(backUpKeyPairCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .failedToDecryptWallet(let error):
                    failedToDecryptWallet(error: error)
                case .finishedBackingUpKeys:
                    finishedBackingUpKeys()
                }
            }
            .onReceive(backupWalletNavigator) { [unowned self] userDid in
                switch userDid {
                case .revealKeystore:
                    toRevealKeystore()
                case .revealPrivateKey:
                    toBackUpRevealedKeyPair()
                case .finishedBackingUpWallet:
                    doneBackingUpWallet()
                }
            }
            .onReceive(backUpKeystoreNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishedBackingUpKeystore:
                    doneBackingUpKeystore()
                }
            }
    
    }
}

// MARK: - Factory
// MARK: -
extension BackupWalletCoordinator {
    
    @ViewBuilder
    func makeBackupWallet() -> some View {
        
        let viewModel = BackupWalletViewModel(
            navigator: backupWalletNavigator,
            wallet: wallet
        )
        
        BackupWalletScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeRevealKeystore() -> some View {
        
        let viewModel = BackUpKeystoreViewModel(
            navigator: backUpKeystoreNavigator,
            wallet: wallet
        )
        
        BackUpKeystoreScreen(viewModel: viewModel)
    }
    
    func makeBackUpRevealedKeyPair() -> NavigationViewCoordinator<BackUpKeyPairCoordinator> {
        NavigationViewCoordinator(
            BackUpKeyPairCoordinator(
                navigator: backUpKeyPairCoordinatorNavigator,
                useCase: walletUseCase,
                wallet: wallet
            )
        )
    }
}
   
// MARK: - Routing
// MARK: -
extension BackupWalletCoordinator {
    
    func failedToDecryptWallet(error: Swift.Error) {
        fatalError("what to do? failedToDecryptWallet: \(error)")
    }
    
    func toRevealKeystore() {
        route(to: \.revealKeystoreRoute)
    }
    
    func toBackUpRevealedKeyPair() {
        route(to: \.revealPrivateKeyRoute)
    }
    
    func finishedBackingUpKeys() {
        self.popLast {
            print("Pop private key")
        }
    }
    
    func revealKeystore() {
        toRevealKeystore()
    }
    func revealPrivateKey() {
        toBackUpRevealedKeyPair()
    }
    
    func doneBackingUpWallet() {
        print("🔮💶 BackupWalletCoordinator:doneBackingUpWallet")
        navigator.step(.userDidBackUpWallet(wallet))
    }
    
    func doneBackingUpKeystore() {
        self.popLast {
            print("Pop keystore")
        }
    }
    
}
