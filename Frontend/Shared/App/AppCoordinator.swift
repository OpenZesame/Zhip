//
//  AppCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import SwiftUI
import Stinsen
import Combine
import ZhipEngine

final class AppCoordinator: NavigationCoordinatable {
    
    var stack: NavigationStack<AppCoordinator>

    @Root var onboarding = makeOnboarding
    @Root var main = makeMain
    
    private let useCaseProvider: UseCaseProvider
    
    private let onboardingCoordinatorNavigator = OnboardingCoordinator.Navigator()
    private let mainCoordinatorNavigator = MainCoordinator.Navigator()
    private let appLifeCyclePublisher: AnyPublisher<ScenePhase, Never>
    
    init(
        useCaseProvider: UseCaseProvider,
        appLifeCyclePublisher: AnyPublisher<ScenePhase, Never>
    ) {
        
        self.useCaseProvider = useCaseProvider
        self.appLifeCyclePublisher = appLifeCyclePublisher
            
        if useCaseProvider.hasWalletConfigured {
            stack = NavigationStack(initial: \.main)
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
                case .finishOnboarding:
                    assert(useCaseProvider.hasWalletConfigured)
                    self.root(\.main)
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
    
    func makeMain() -> MainCoordinator {
        MainCoordinator(
            appLifeCyclePublisher: appLifeCyclePublisher,
            navigator: mainCoordinatorNavigator,
            useCaseProvider: useCaseProvider
        )
    }
}

