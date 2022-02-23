//
//  SetupPINCodeCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

enum SetupPINCoordinatorNavigationStep {
    case finishedPINSetup
}

// MARK: - SetupPINCodeCoordinator
// MARK: -
final class SetupPINCodeCoordinator: NavigationCoordinatable {
    
    typealias Navigator = NavigationStepper<SetupPINCoordinatorNavigationStep>
    
    let stack = NavigationStack<SetupPINCodeCoordinator>(initial: \.newPIN)
    @Root var newPIN = makeNewPIN
    @Route(.push) var confirmPIN = makeConfirmPIN(expectedPIN:)
    
    private let newPinNavigator = NewPINCodeViewModel.Navigator()
    private let confirmNewPinNavigator = ConfirmNewPINCodeViewModel.Navigator()
    private unowned let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension SetupPINCodeCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(newPinNavigator) { userDid in
                switch userDid {
                case .setPIN(let newPin):
                    self.route(to: \.confirmPIN, newPin)
                case .skipSettingPin:
                    print("👻 skip setting pin => dismiss")
                    self.dismissCoordinator {
                        print("dismissing  SetupPINCodeCoordinator")
                    }
                }
            }
        
    }
}
    
// MARK: - Factory
// MARK: -
extension SetupPINCodeCoordinator {
    @ViewBuilder
    func makeNewPIN() -> some View {
        let viewModel = DefaultNewPINCodeViewModel(navigator: newPinNavigator)
        NewPINCodeScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeConfirmPIN(expectedPIN: Pincode) -> some View {
        let viewModel = DefaultConfirmNewPINCodeViewModel(
            navigator: confirmNewPinNavigator,
            expectedPIN: expectedPIN
        )
        ConfirmNewPINCodeScreen(viewModel: viewModel)
    }
}
