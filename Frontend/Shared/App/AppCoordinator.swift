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
    
    private let useCaseProvider: UseCaseProvider
    
    private let onboardingCoordinatorNavigator = OnboardingCoordinator.Navigator()
    private let mainCoordinatorNavigator = MainCoordinator.Navigator()
    
    init(
        useCaseProvider: UseCaseProvider
    ) {
        
        self.useCaseProvider = useCaseProvider
            
        if let wallet = useCaseProvider.makeWalletUseCase().loadWallet() {
            stack = NavigationStack(initial: \.main, wallet)
        } else {
            stack = NavigationStack(initial: \.onboarding)
        }
    }
    
    deinit {
        print("✅ AppCoordinator DEINIT 💣")
    }
}

// MARK: - NavigationCoordinatable
// MARK: -
extension AppCoordinator {
    @ViewBuilder func customize(_ view: AnyView) -> some View {
        view
            .onReceive(onboardingCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .finishOnboarding(let wallet):
                    self.root(\.main, wallet)
                }
            }
            .onReceive(mainCoordinatorNavigator) { [unowned self] userDid in
                switch userDid {
                case .userDeletedWallet:
                    print("🎬 AppCoordinator: userDeletedWallet")
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
                navigator: onboardingCoordinatorNavigator,
                useCaseProvider: useCaseProvider
            )
        )
    }
    
    func makeMain(wallet: Wallet) -> MainCoordinator {
        MainCoordinator(
            navigator: mainCoordinatorNavigator,
            useCaseProvider: useCaseProvider,
            wallet: wallet
        )
    }
}

