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
    
    private let onboardingNavigator = OnboardingCoordinator.Navigator()
    private let mainNavigator = MainCoordinator.Navigator()
    
    init(
        model: Model, // TODO: SHOULD? MUST? Be: `ObservedObject<Model>` ?
        useCaseProvider: UseCaseProvider
    ) {
        
        self.model = model
        self.useCaseProvider = useCaseProvider
            
        switch model.wallet {
        case .some(let wallet):
            stack = NavigationStack(initial: \.main, wallet)
        case .none:
            stack = NavigationStack(initial: \.onboarding)
        }
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension AppCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(onboardingNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishOnboarding:
                    self.root(\.main)
                }
            }
            .onReceive(mainNavigator) { [unowned self] userDid in
                switch userDid {
                case .userDeletedWallet:
                    self.root(\.onboarding)
                }
            }
        
    }
}


// MARK: - Factory
// MARK: -
extension AppCoordinator {
    func makeOnboarding() -> NavigationViewCoordinator<OnboardingCoordinator> {
        NavigationViewCoordinator(
            OnboardingCoordinator(
                navigator: onboardingNavigator,
                useCaseProvider: useCaseProvider
            )
        )
    }
    
    func makeMain(wallet: Wallet) -> MainCoordinator {
        MainCoordinator(
            navigator: mainNavigator,
            wallet: wallet
        )
    }
}

