//
//  NewWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

// MARK: - RestoreOrGenerateNewWalletCoordinator
// MARK: -
protocol RestoreOrGenerateNewWalletCoordinator: AnyObject {
    func privacyIsEnsured()
    func myScreenMightBeWatched()
}

// MARK: - NewWalletCoordinator
// MARK: -
protocol NewWalletCoordinator: AnyObject {
    func didGenerateNew(wallet: Wallet)
    func failedToGenerateNewWallet(error: Swift.Error)
}

private final class BackUpWalletState: ObservableObject {
    @Published var hasBackedUpWallet = false
}


// MARK: - DefaultNewWalletCoordinator
// MARK: -
final class DefaultNewWalletCoordinator: RestoreOrGenerateNewWalletCoordinator, NewWalletCoordinator, NavigationCoordinatable {
    let stack: NavigationStack<DefaultNewWalletCoordinator> = .init(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var newEncryptionPassword = makeGenerateNewWallet
    @Route(.push) var backupWallet = makeBackupWalletCoordinator(wallet:)

    // Root, because we replace navigation stack
    @Root var nameWallet = makeNameWallet
    
    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    //    @StateObject
    @ObservedObject private var backUpWalletState = BackUpWalletState()
    
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("deinit DefaultNewWalletCoordinator")
    }

}

// MARK: - NavigationCoordinatable
// MARK: -
extension DefaultNewWalletCoordinator {
    
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(backUpWalletState.$hasBackedUpWallet, perform: { hasBackedUpWallet in
                if hasBackedUpWallet {
                    self.root(\.nameWallet)
                } else {
                    self.root(\.ensurePrivacy)
                }
            })
            
    }
}

// MARK: - Factory
// MARK: -
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
        let viewModel = DefaultNameWalletViewModel()
        NameWalletScreen(viewModel: viewModel)
    }
    
    func makeBackupWalletCoordinator(wallet: Wallet) -> NavigationViewCoordinator<DefaultBackupWalletCoordinator> {
       
        let backupWalletCoordinator = DefaultBackupWalletCoordinator(
            useCaseProvider: useCaseProvider,
            wallet: wallet
        ) { [unowned backUpWalletState] in
            print("backUpWalletState.hasBackedUpWallet = true")
            backUpWalletState.hasBackedUpWallet = true
        }
        
        return NavigationViewCoordinator(backupWalletCoordinator)
    }
    
}



// MARK: - NewWalletC. Conformance
// MARK: -
extension DefaultNewWalletCoordinator {

    func didGenerateNew(wallet: Wallet) {
        toBackupWallet(wallet: wallet)
    }
    
    func failedToGenerateNewWallet(error: Swift.Error) {
        print("Failed to generate new wallet, error: \(error)")
        
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}

// MARK: - RestoreOrGenerateC. Conformance
// MARK: -
extension DefaultNewWalletCoordinator {

    func privacyIsEnsured() {
        toGenerateNewWallet()
    }
    
    func myScreenMightBeWatched() {
        dismissCoordinator {
            print("dismissing \(self)")
        }
    }
}

// MARK: - Routing
// MARK: -
extension DefaultNewWalletCoordinator {

    func toBackupWallet(wallet: Wallet) {
        route(to: \.backupWallet, wallet)
    }
    
    func toGenerateNewWallet() {
        route(to: \.newEncryptionPassword)
    }
    

}
