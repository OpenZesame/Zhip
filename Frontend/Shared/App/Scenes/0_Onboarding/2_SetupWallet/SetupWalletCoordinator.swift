//
//  SetupWalletCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine
import Combine

enum SetupWalletNavigationStep {
    case finishSettingUpWallet(wallet: Wallet)
}

// MARK: - SetupWalletCoordinator
// MARK: -
protocol SetupWalletCoordinator: AnyObject {
    func generateNewWallet()
    func restoreExistingWallet()
}

// MARK: - DefaultSetupWalletCoordinator
// MARK: -
final class DefaultSetupWalletCoordinator: NavigationCoordinatable, SetupWalletCoordinator {
    
    let stack = NavigationStack<DefaultSetupWalletCoordinator>(initial: \.setupWallet)

    @Root var setupWallet = makeSetupWallet
    @Route(.modal) var newWallet = makeNewWallet
    @Route(.modal) var restoreWallet = makeRestoreWallet
    
    private let newWalletNavigator: DefaultNewWalletCoordinator.Navigator = .init()
    
    private let useCaseProvider: UseCaseProvider
    typealias Navigator = PassthroughSubject<SetupWalletNavigationStep, Never>
    private unowned let navigator: Navigator
    
    init(useCaseProvider: UseCaseProvider, navigator: Navigator) {
        self.useCaseProvider = useCaseProvider
        self.navigator = navigator
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension DefaultSetupWalletCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(newWalletNavigator.eraseToAnyPublisher(), perform: { userDid in
                switch userDid {
                case .create(let wallet):
                    self.navigator.send(.finishSettingUpWallet(wallet: wallet))
                    self.dismissCoordinator {
                        print("dismiss: \(self)")
                    }
                case .cancel:
                    print("user cancelled setting up wallet.")
                    self.dismissCoordinator {
                        print("dismiss: \(self)")
                    }
                }
            })
        
    }
}

// MARK: - SetupWalletC. Conformance
// MARK: -
extension DefaultSetupWalletCoordinator {
    func generateNewWallet() {
        toGenerateNewWallet()
    }
    
    func restoreExistingWallet() {
        toRestoreExistingWallet()
    }
 
}

// MARK: - Routing
// MARK: -
extension DefaultSetupWalletCoordinator {
    
    func toGenerateNewWallet() {
        route(to: \.newWallet)
    }
    
    func toRestoreExistingWallet() {
        route(to: \.restoreWallet)
    }
}

// MARK: - Factory
// MARK: -
extension DefaultSetupWalletCoordinator {
    
    @ViewBuilder
    func makeSetupWallet() -> some View {
        let viewModel = DefaultSetupWalletViewModel(coordinator: self)
        SetupWalletScreen(viewModel: viewModel)
    }
    
    func makeNewWallet() -> NavigationViewCoordinator<DefaultNewWalletCoordinator> {
        let newWalletCoordinator = DefaultNewWalletCoordinator(
            useCaseProvider: useCaseProvider,
            navigator: newWalletNavigator
        )
        
        return NavigationViewCoordinator(
            newWalletCoordinator
        )
    }
    
    func makeRestoreWallet() -> NavigationViewCoordinator<DefaultRestoreWalletCoordinator> {
        .init(DefaultRestoreWalletCoordinator())
    }
    
}

