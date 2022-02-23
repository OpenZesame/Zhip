//
//  TransferCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen

final class TransferCoordinator: NavigationCoordinatable {
    let stack = NavigationStack<TransferCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    @ViewBuilder
    func makeStart() -> some View {
        TransferScreen()
    }
}
