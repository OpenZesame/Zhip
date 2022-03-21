////
////  AppCoordinator.swift
////  Zhip
////
////  Created by Alexander Cyon on 2022-02-12.
////
//
//import SwiftUI
//import Stinsen
//import Combine
//import ZhipEngine
//
//final class AppCoordinator: NavigationCoordinatable {
//    
//    var stack: NavigationStack<AppCoordinator>
//
//    @Root var onboarding = makeOnboarding
//    @Root var main = makeMain
//    
//    private let useCaseProvider: UseCaseProvider
//    
//    private let onboardingCoordinatorNavigator = OnboardingCoordinator.Navigator()
//    private let mainCoordinatorNavigator = MainCoordinator.Navigator()
//    private let appLifeCyclePublisher: AnyPublisher<ScenePhase, Never>
//    
//    init(
//        useCaseProvider: UseCaseProvider,
//        appLifeCyclePublisher: AnyPublisher<ScenePhase, Never>
//    ) {
//        
//        self.useCaseProvider = useCaseProvider
//        self.appLifeCyclePublisher = appLifeCyclePublisher
//            
//        if useCaseProvider.hasWalletConfigured {
//            let promptUserToUnlockAppIfNeeded = true
//            stack = NavigationStack(initial: \.main, promptUserToUnlockAppIfNeeded)
//        } else {
//            stack = NavigationStack(initial: \.onboarding)
//        }
//    }
//    
//    deinit {
//        print("✅ AppCoordinator DEINIT 💣")
//    }
//}
//
//// MARK: - NavigationCoordinatable
//// MARK: -
//extension AppCoordinator {
//    @ViewBuilder func customize(_ view: AnyView) -> some View {
//        view
//            .onReceive(onboardingCoordinatorNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .finishOnboarding:
//                    assert(useCaseProvider.hasWalletConfigured)
//                    let promptUserToUnlockAppIfNeeded = false
//                    self.root(\.main, promptUserToUnlockAppIfNeeded) // Avoid locking app for PIN entry
//                }
//            }
//            .onReceive(mainCoordinatorNavigator) { [unowned self] userDid in
//                switch userDid {
//                case .userDeletedWallet:
//                    print("🎬 AppCoordinator: userDeletedWallet")
//                    self.root(\.onboarding)
//                }
//            }
//    }
//}
//
//
//// MARK: - Factory
//// MARK: -
//extension AppCoordinator {
//    func makeOnboarding() -> NavigationViewCoordinator<OnboardingCoordinator> {
//        NavigationViewCoordinator(
//            OnboardingCoordinator(
//                navigator: onboardingCoordinatorNavigator,
//                useCaseProvider: useCaseProvider
//            )
//        )
//    }
//    
//    func makeMain(promptUserToUnlockAppIfNeeded: Bool) -> MainCoordinator {
//        MainCoordinator(
//            appLifeCyclePublisher: appLifeCyclePublisher,
//            navigator: mainCoordinatorNavigator,
//            useCaseProvider: useCaseProvider,
//            promptUserToUnlockAppIfNeeded: promptUserToUnlockAppIfNeeded
//        )
//    }
//}
//
