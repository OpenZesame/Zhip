//
//  SetupPINCodeCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

protocol SetupPINCodeCoordinator: AnyObject {
    
}

final class DefaultSetupPINCodeCoordinator: SetupPINCodeCoordinator, NavigationCoordinatable {
    let stack = NavigationStack<DefaultSetupPINCodeCoordinator>(initial: \.newPIN)
    @Root var newPIN = makeNewPIN
    
    @ViewBuilder
    func makeNewPIN() -> some View {
        NewPINCodeScreen()
    }
}
