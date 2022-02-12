//
//  AppCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import ZhipEngine

final class AppCoordinator: NavigationCoordinatable {
    
    @EnvironmentObject private var model: Model
    
    var stack: NavigationStack<AppCoordinator>

    @Root var onboarding = makeOnboarding
    @Root var main = makeMain
    
    
    init(model: Model) {
        switch model.wallet {
        case .some(let wallet):
            stack = NavigationStack(initial: \AppCoordinator.main, wallet)
        case .none:
            stack = NavigationStack(initial: \AppCoordinator.onboarding, DefaultSetupWalletUseCase())
        }
    }
    
    @ViewBuilder func sharedView(_ view: AnyView) -> some View {
        view
            .onReceive(model.$wallet, perform: { [self] wallet in
                switch wallet {
                case .some(let wallet):
                    self.stack = NavigationStack(initial: \AppCoordinator.main, wallet)
                case .none:
                    self.stack = NavigationStack(initial: \AppCoordinator.onboarding, DefaultSetupWalletUseCase())
                }
            })
        
    }
}



extension AppCoordinator {
    func makeOnboarding(setupWalletUseCase: SetupWalletUseCase) -> NavigationViewCoordinator<DefaultOnboardingCoordinator> {
        NavigationViewCoordinator(DefaultOnboardingCoordinator(setupWalletUseCase: setupWalletUseCase))
    }
    
    func makeMain(wallet: Wallet) -> MainCoordinator {
        MainCoordinator(wallet: wallet)
    }
}

