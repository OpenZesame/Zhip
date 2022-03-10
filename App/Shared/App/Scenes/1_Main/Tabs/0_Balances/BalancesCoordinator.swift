//
//  BalancesCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import SwiftUI
import Stinsen
import ZhipEngine
import Styleguide

// MARK: - BalancesCoordinator
// MARK: -
final class BalancesCoordinator: NavigationCoordinatable {
   
    let stack = NavigationStack<BalancesCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    private let walletUseCase: WalletUseCase
    private let balancesUseCase: BalancesUseCase
    
    init(balancesUseCase: BalancesUseCase, walletUseCase: WalletUseCase) {
        self.balancesUseCase = balancesUseCase
        self.walletUseCase = walletUseCase
    }

    deinit {
        print("✅ BalancesCoordinator DEINIT 💣")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension BalancesCoordinator {
    func customize(_ view: AnyView) -> some View {
        ForceFullScreen {
            view
        }
    }
}
    
// MARK: - Factory
// MARK: -
extension BalancesCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        let viewModel = BalancesViewModel(
            balancesUseCase: balancesUseCase,
            walletUseCase: walletUseCase
        )
        BalancesScreen(viewModel: viewModel)
    }
}

