//
//  ContactsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen

final class ContactsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<ContactsCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    @ViewBuilder
    func makeStart() -> some View {
        ContactsScreen()
    }
}

