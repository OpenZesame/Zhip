//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

protocol RestoreOrGenerateNewWalletCoordinator: AnyObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}

protocol NewWalletCoordinator: AnyObject {
    func didGenerateNew(wallet: Wallet)
    func failedToGenerateNewWallet(error: Swift.Error)
}

final class DefaultNewWalletCoordinator: RestoreOrGenerateNewWalletCoordinator, NewWalletCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultNewWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var newEncryptionPassword = makeGenerateNewWallet
    @Route(.push) var backupWallet = makeBackupWalletCoordinator(wallet:)
    @Route(.push) var nameWallet = makeNameWallet
    
    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("deinit DefaultNewWalletCoordinator")
    }

}

extension DefaultNewWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        let viewModel = DefaultEnsurePrivacyViewModel<DefaultNewWalletCoordinator>(coordinator: self)
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
    
    @ViewBuilder
    func makeNameWallet() -> some View {
        NameWalletScreen()
    }
  
    func privacyIsEnsured() {
        toGenerateNewWallet()
    }
    
    func didGenerateNew(wallet: Wallet) {
        toBackupWallet(wallet: wallet)
    }
    
    func failedToGenerateNewWallet(error: Swift.Error) {
        print("Failed to generate new wallet, error: \(error)")
        
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
    
    func makeBackupWalletCoordinator(wallet: Wallet) -> NavigationViewCoordinator<DefaultBackupWalletCoordinator> {
        .init(DefaultBackupWalletCoordinator(useCaseProvider: useCaseProvider, wallet: wallet))
    }
   
    func toBackupWallet(wallet: Wallet) {
        route(to: \.backupWallet, wallet)
    }
    
    func toGenerateNewWallet() {
        route(to: \.newEncryptionPassword)
    }
    
    func myScreenMightBeWatched() {
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}
