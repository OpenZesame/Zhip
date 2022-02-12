//
//  SetupPINCodeCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen

final class SetupPINCodeCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<SetupPINCodeCoordinator>(initial: \SetupPINCodeCoordinator.newPIN)
    @Root var newPIN = makeNewPIN
    
    @ViewBuilder
    func makeNewPIN() -> some View {
        NewPINCodeScreen()
    }
}
