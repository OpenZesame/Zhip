//
//  SettingsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen

enum SettingsCoordinatorNavigationStep {
    case userDeletedWallet
}

final class SettingsCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<SettingsCoordinatorNavigationStep>
    
    let stack = NavigationStack<SettingsCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    private lazy var settingsNavigator = SettingsViewModel.Navigator()
    
    private unowned let navigator: Navigator
    private let useCaseProvider: UseCaseProvider
    
    init(navigator: Navigator, useCaseProvider: UseCaseProvider) {
        self.navigator = navigator
        self.useCaseProvider = useCaseProvider
    }
}


// MARK: - NavigationCoordinatable
// MARK: -
extension SettingsCoordinator {
    
    @ViewBuilder
    func customize(_ view: AnyView) -> some View {
        ForceFullScreen { [unowned self] in
            view
                .onReceive(settingsNavigator) { userDid in
                    switch userDid {
                    case .deleteWallet:
                        navigator.step(.userDeletedWallet)
                    }
                }
        }
    }
    
}


// MARK: - Factory
// MARK: -
extension SettingsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        let viewModel = SettingsViewModel(
            navigator: settingsNavigator,
            useCase: useCaseProvider.makeWalletUseCase()
        )
        SettingsScreen(viewModel: viewModel)
    }
}
