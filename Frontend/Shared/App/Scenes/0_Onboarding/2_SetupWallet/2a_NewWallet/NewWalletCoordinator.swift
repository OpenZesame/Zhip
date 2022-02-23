//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine
import Combine

enum NewWalletCoordinatorNavigationStep {
    case create(wallet: Wallet)
    case cancel
}

// MARK: - NewWalletCoordinator
// MARK: -
final class NewWalletCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<NewWalletCoordinatorNavigationStep>
    
    let stack: NavigationStack<NewWalletCoordinator> = .init(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var newEncryptionPassword = makeGenerateNewWallet
    @Route(.push) var backupWallet = makeBackupWalletCoordinator(wallet:)
    
    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    private unowned let navigator: Navigator
    private let backupWalletCoordinatorNavigator = BackupWalletCoordinator.Navigator()
    private let ensurePrivacyNavigator = EnsurePrivacyViewModel.Navigator()
    
    init(
        navigator: Navigator,
        useCaseProvider: UseCaseProvider
    ) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("deinit NewWalletCoordinator")
    }

}

// MARK: - NavigationCoordinatable
// MARK: -
extension NewWalletCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {

        view
            .onReceive(backupWalletCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .userDidBackUpWallet(let wallet):
                    self.navigator.step(.create(wallet: wallet))
                }
            }
            .onReceive(ensurePrivacyNavigator) { [unowned self] userDid in
                switch userDid {
                case .ensurePrivacy: self.privacyIsEnsured()
                case .thinkScreenMightBeWatched: self.myScreenMightBeWatched()
                }
            }
    }
}

// MARK: - Factory
// MARK: -
extension NewWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        let viewModel = DefaultEnsurePrivacyViewModel(navigator: ensurePrivacyNavigator)
        EnsurePrivacyScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeGenerateNewWallet() -> some View {
        
        let viewModel = DefaultGenerateNewWalletViewModel(
            coordinator: self,
            useCase: walletUseCase
        )
        
        GenerateNewWalletScreen(viewModel: viewModel)
    }
    
    func makeBackupWalletCoordinator(wallet: Wallet) -> NavigationViewCoordinator<BackupWalletCoordinator> {
       
        let backupWalletCoordinator = BackupWalletCoordinator(
            navigator: backupWalletCoordinatorNavigator,
            useCaseProvider: useCaseProvider,
            wallet: wallet
        )
        return NavigationViewCoordinator(backupWalletCoordinator)
    }
    
}


// MARK: - Routing
// MARK: -
extension NewWalletCoordinator {
    
    func didGenerateNew(wallet: Wallet) {
        toBackupWallet(wallet: wallet)
    }
    
    func failedToGenerateNewWallet(error: Swift.Error) {
        print("Failed to generate new wallet, error: \(error)")
        
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
    
    func privacyIsEnsured() {
        toGenerateNewWallet()
    }
    
    func myScreenMightBeWatched() {
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }

    func toBackupWallet(wallet: Wallet) {
        route(to: \.backupWallet, wallet)
    }
    
    func toGenerateNewWallet() {
        route(to: \.newEncryptionPassword)
    }
    

}
