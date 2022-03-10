//
//  ContactsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen
import Styleguide

final class ContactsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<ContactsCoordinator>(initial: \.start)
    @Root var start = makeStart
}

// MARK: - NavigationCoordinatable
// MARK: -
extension ContactsCoordinator {
    func customize(_ view: AnyView) -> some View {
        ForceFullScreen {
            view
        }
    }
}

// MARK: - Factory
// MARK: -
extension ContactsCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        ContactsScreen()
    }
}
