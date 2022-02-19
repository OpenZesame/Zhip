//
//  SetupPINCodeCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

// MARK: - SetupPINCodeCoordinator
// MARK: -
protocol SetupPINCodeCoordinator: AnyObject {}

// MARK: - DefaultSetupPINCodeCoordinator
// MARK: -
final class DefaultSetupPINCodeCoordinator: SetupPINCodeCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultSetupPINCodeCoordinator>(initial: \.newPIN)
    @Root var newPIN = makeNewPIN
}
    
// MARK: - Factory
// MARK: -
extension DefaultSetupPINCodeCoordinator {
    @ViewBuilder
    func makeNewPIN() -> some View {
        NewPINCodeScreen()
    }
}
