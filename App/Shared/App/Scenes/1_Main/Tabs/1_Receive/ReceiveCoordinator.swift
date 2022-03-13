//
//  1_Receive.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-25.
//

import SwiftUI
import Stinsen
import ZhipEngine
import Styleguide
import Screen

// MARK: - ReceiveCoordinator
// MARK: -
final class ReceiveCoordinator: NavigationCoordinatable {
   
    let stack = NavigationStack<ReceiveCoordinator>(initial: \.start)
    @Root var start = makeStart
    
    private let walletUseCase: WalletUseCase
    
    init(walletUseCase: WalletUseCase) {
        self.walletUseCase = walletUseCase
    }

    deinit {
        print("✅ ReceiveCoordinator DEINIT 💣")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension ReceiveCoordinator {
    func customize(_ view: AnyView) -> some View {
        ForceFullScreen {
            view
        }
    }
}
    
// MARK: - Factory
// MARK: -
extension ReceiveCoordinator {
    @ViewBuilder
    func makeStart() -> some View {
        let viewModel = ReceiveViewModel(
            walletUseCase: walletUseCase
        )
        ReceiveScreen(viewModel: viewModel)
    }
}

