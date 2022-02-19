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
    
    var stack: NavigationStack<AppCoordinator>

    @Root var onboarding = makeOnboarding
    @Root var main = makeMain
    
    private let model: Model // TODO: SHOULD? MUST? Be: `@ObservedObject var model: Model`?
    private let useCaseProvider: UseCaseProvider
    
    init(
        model: Model, // TODO: SHOULD? MUST? Be: `ObservedObject<Model>` ?
        useCaseProvider: UseCaseProvider) {
        self.model = model
        self.useCaseProvider = useCaseProvider
        switch model.wallet {
        case .some(let wallet):
            stack = NavigationStack(initial: \AppCoordinator.main, wallet)
        case .none:
            stack = NavigationStack(initial: \AppCoordinator.onboarding)
        }
    }
    
    @ViewBuilder func sharedView(_ view: AnyView) -> some View {
        view
            .onReceive(model.$wallet, perform: { [self] wallet in
                switch wallet {
                case .some(let wallet):
                    self.stack = NavigationStack(initial: \AppCoordinator.main, wallet)
                case .none:
                    self.stack = NavigationStack(initial: \AppCoordinator.onboarding)
                }
            })
        
    }
}



extension AppCoordinator {
    func makeOnboarding() -> NavigationViewCoordinator<DefaultOnboardingCoordinator> {
        NavigationViewCoordinator(DefaultOnboardingCoordinator(useCaseProvider: useCaseProvider))
    }
    
    func makeMain(wallet: Wallet) -> MainCoordinator {
        MainCoordinator(wallet: wallet)
    }
}

