//
//  TransferCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen
import Styleguide

final class TransferCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<TransferCoordinator>(initial: \.start)
    @Root var start = makeStart
}

// MARK: - NavigationCoordinatable
// MARK: -
extension TransferCoordinator {
    func customize(_ view: AnyView) -> some View {
        ForceFullScreen {
            view
        }
    }
}

// MARK: - Factory
// MARK: -
extension TransferCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        TransferScreen()
    }
}
