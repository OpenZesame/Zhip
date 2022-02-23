//
//  BalancesCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen
import ZhipEngine

// MARK: - BalancesCoordinator
// MARK: -
final class BalancesCoordinator: NavigationCoordinatable {
   
    let stack = NavigationStack<BalancesCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    let wallet: Wallet
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
}
    
// MARK: - Factory
// MARK: -
extension BalancesCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        BalancesScreen(wallet: wallet)
    }
}

