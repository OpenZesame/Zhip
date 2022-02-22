//
//  SetupPINCodeCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

//enum SetupPINCoordinatorNavigationStep {
//    case done
//}

// MARK: - SetupPINCodeCoordinator
// MARK: -
protocol SetupPINCodeCoordinator: AnyObject {}

// MARK: - DefaultSetupPINCodeCoordinator
// MARK: -
final class DefaultSetupPINCodeCoordinator: SetupPINCodeCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultSetupPINCodeCoordinator>(initial: \.newPIN)
    @Root var newPIN = makeNewPIN
    @Route(.push) var confirmPIN = makeConfirmPIN(expectedPIN:)
    
    private let newPinNavigator = NewPINCodeViewModel.Navigator()
}

// MARK: - NavigationCoordinatable
// MARK: -
extension DefaultSetupPINCodeCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(newPinNavigator) { userDid in
                switch userDid {
                case .setPIN(let newPin):
                    self.route(to: \.confirmPIN, newPin)
                case .skipSettingPin:
                    print("👻 skip setting pin => dismiss")
                    self.dismissCoordinator {
                        print("dismissing  DefaultSetupPINCodeCoordinator")
                    }
                }
            }
        
    }
}

    
// MARK: - Factory
// MARK: -
extension DefaultSetupPINCodeCoordinator {
    @ViewBuilder
    func makeNewPIN() -> some View {
        let viewModel = DefaultNewPINCodeViewModel(navigator: newPinNavigator)
        NewPINCodeScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    func makeConfirmPIN(expectedPIN: Pincode) -> some View {
        let viewModel = DefaultConfirmNewPINCodeViewModel(expectedPIN: expectedPIN)
        ConfirmNewPINCodeScreen(viewModel: viewModel)
    }
}
