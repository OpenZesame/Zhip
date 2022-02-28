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
    case abortBecauseScreenMightBeWatched
    case cancel
}

// MARK: - NewWalletCoordinator
// MARK: -
final class NewWalletCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<NewWalletCoordinatorNavigationStep>
    
    let stack: NavigationStack<NewWalletCoordinator> = .init(initial: \.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var newEncryptionPassword = makeGenerateNewWallet
    @Route(.push) var backupWallet = makeBackUpWalletCoordinator(wallet:)
    
    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    private unowned let navigator: Navigator
    private lazy var generateNewWalletNavigator = GenerateNewWalletViewModel.Navigator()
    private lazy var backupWalletCoordinatorNavigator = BackUpWalletCoordinator.Navigator()
    private lazy var ensurePrivacyNavigator = EnsurePrivacyViewModel.Navigator()
    
    init(
        navigator: Navigator,
        useCaseProvider: UseCaseProvider
    ) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
    
    deinit {
        print("✅ NewWalletCoordinator DEINIT 💣")
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
                   userFinishedBackingUpNewlyCreatedWallet(wallet)
                }
            }
            .onReceive(ensurePrivacyNavigator) { [unowned self] userDid in
                switch userDid {
                case .ensurePrivacy: self.privacyIsEnsured()
                case .thinkScreenMightBeWatched: self.myScreenMightBeWatched()
                }
            }
            .onReceive(generateNewWalletNavigator) { [unowned self] userDid in
                switch userDid {
                case .failedToGenerateNewWallet(let error):
                    failedToGenerateNewWallet(error: error)
                case .didGenerateNew(let wallet):
                    didGenerateNew(wallet: wallet)
                }
            }
    }
}

// MARK: - Factory
// MARK: -
extension NewWalletCoordinator {
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        let viewModel = EnsurePrivacyViewModel(navigator: ensurePrivacyNavigator)
        EnsurePrivacyScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeGenerateNewWallet() -> some View {
        
        let viewModel = GenerateNewWalletViewModel(
            navigator: generateNewWalletNavigator,
            useCase: walletUseCase
        )
        
        GenerateNewWalletScreen(viewModel: viewModel)
    }
    
    func makeBackUpWalletCoordinator(wallet: Wallet) -> NavigationViewCoordinator<BackUpWalletCoordinator> {
       
        let backupWalletCoordinator = BackUpWalletCoordinator(
            mode: .mandatoryBackUpPartOfOnboarding,
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
    
    func userFinishedBackingUpNewlyCreatedWallet(_ wallet: Wallet) {
        self.navigator.step(.create(wallet: wallet))
    }
    
    func didGenerateNew(wallet: Wallet) {
        toBackUpWallet(wallet: wallet)
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
        navigator.step(.abortBecauseScreenMightBeWatched)
    }

    func toBackUpWallet(wallet: Wallet) {
        route(to: \.backupWallet, wallet)
    }
    
    func toGenerateNewWallet() {
        route(to: \.newEncryptionPassword)
    }
    

}
