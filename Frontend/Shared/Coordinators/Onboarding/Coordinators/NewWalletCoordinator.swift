//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol RestoreOrGenerateNewWalletCoordinator: AnyObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}

protocol NewWalletCoordinator: AnyObject {
    func encryptionPasswordIsSet()
}

final class DefaultNewWalletCoordinator: RestoreOrGenerateNewWalletCoordinator, NewWalletCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultNewWalletCoordinator>(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var newEncryptionPassword = makeNewEncryptionPassword
    @Route(.push) var nameWallet = makeNameWallet
    @Route(.push) var backupWallet = makeBackupWallet
    
    
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
    func makeNewEncryptionPassword() -> some View {
        
        let viewModel = DefaultNewEncryptionPasswordViewModel(
            coordinator: self,
            useCase: walletUseCase
        )
        
        NewEncryptionPasswordScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeNameWallet() -> some View {
        NameWalletScreen()
    }
    
    @ViewBuilder
    func makeBackupWallet() -> some View {
        BackupWalletScreen()
    }
    
    func privacyIsEnsured() {
        toNewEncryptionPassword()
    }
    
    func encryptionPasswordIsSet() {
        toBackupWallet()
    }
    
    func toBackupWallet() {
        route(to: \.backupWallet)
    }
    
    func toNewEncryptionPassword() {
        route(to: \.newEncryptionPassword)
    }
    
    func myScreenMightBeWatched() {
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}
