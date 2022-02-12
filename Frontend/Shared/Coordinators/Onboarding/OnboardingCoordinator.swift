//
//  OnboardingCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI

import ZhipEngine
import Stinsen

struct TermsOfServiceScreen: View {
    var body: some View {
        Text("Terms of Service")
    }
}

struct EnsurePrivacyScreen: View {
    var body: some View {
        Text("Ensure privacy")
    }
}
struct RestoreWalletScreen: View {
    var body: some View {
        Text("Restore Wallet")
    }
}
struct NewWalletScreen: View {
    var body: some View {
        Text("New Wallet")
    }
}


final class NewWalletCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<NewWalletCoordinator>(initial: \NewWalletCoordinator.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var new = makeNew
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        EnsurePrivacyScreen()
    }
    
    
    @ViewBuilder
    func makeNew() -> some View {
        NewWalletScreen()
    }
}

final class RestoreWalletCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<RestoreWalletCoordinator>(initial: \RestoreWalletCoordinator.ensurePrivacy)
    
    @Root var ensurePrivacy = makeEnsurePrivacy
    @Route(.push) var restore = makeRestore
    
    @ViewBuilder
    func makeEnsurePrivacy() -> some View {
        EnsurePrivacyScreen()
    }
    
    
    @ViewBuilder
    func makeRestore() -> some View {
        RestoreWalletScreen()
    }
}

final class SetupWalletCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<SetupWalletCoordinator>(initial: \SetupWalletCoordinator.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    @ViewBuilder
    func makeSetupWallet() -> some View {
        SetupWalletScreen()
    }
    
    func makeNewWallet() -> NavigationViewCoordinator<NewWalletCoordinator> {
        .init(NewWalletCoordinator())
    }
    
    func makeRestoreWallet() -> NavigationViewCoordinator<RestoreWalletCoordinator> {
        .init(RestoreWalletCoordinator())
    }
    
}

protocol OnboardingCoordinator {
    func didStart()
}

final class DefaultOnboardingCoordinator: NavigationCoordinatable, OnboardingCoordinator {
    
    
    private let setupWalletUseCase: SetupWalletUseCase
    init(setupWalletUseCase: SetupWalletUseCase) {
        self.setupWalletUseCase = setupWalletUseCase
    }

    let stack = NavigationStack(initial: \DefaultOnboardingCoordinator.welcome)
    
    @Root var welcome = makeWelcome
    @Route(.push) var termsOfService = makeTermsOfService
    
    // Replace navigation stack
    @Root var setupWallet = makeSetupWallet

    // Replace navigation stack
    @Root var setupPINCode = makeSetupPINCode
    
    // This is used to define which protocol that should be used when storing the router. It's used together with @RouterObject in DefaultWelcomeViewModel. If you don't use RouterObject, or if you do not need a protocol for LoginCoordinator, this can be removed.
    
    lazy var routerStorable: OnboardingCoordinator = self
   
    
    func didStart() {
        toSetupWallet()
    }
    
    private func toSetupWallet() {
        self.root(\.setupWallet)
    }
    
    deinit {
        print("Deinit OnboardingCoordinator")
    }
}

struct NewPINCodeScreen: View {
    var body: some View {
        Text("New PIN")
    }
}

final class SetupPINCodeCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<SetupPINCodeCoordinator>(initial: \SetupPINCodeCoordinator.newPIN)
    @Root var newPIN = makeNewPIN
    
    @ViewBuilder
    func makeNewPIN() -> some View {
        NewPINCodeScreen()
    }
}


// MARK: - Factory
// MARK: -
private extension DefaultOnboardingCoordinator {
    
    @ViewBuilder
    func makeTermsOfService() -> some View {
        TermsOfServiceScreen()
    }
    
    func makeSetupWallet() -> NavigationViewCoordinator<SetupWalletCoordinator> {
        NavigationViewCoordinator(SetupWalletCoordinator())
    }
    
    func makeSetupPINCode(wallet: Wallet) -> SetupPINCodeCoordinator {
        SetupPINCodeCoordinator()
    }
    
    @ViewBuilder
    func makeWelcome() -> some View {
        WelcomeScreen(viewModel: DefaultWelcomeViewModel())
    }
}
