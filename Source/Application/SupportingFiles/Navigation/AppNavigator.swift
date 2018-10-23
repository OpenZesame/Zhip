//
//  AppCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class AppCoordinator {

    private let window: UIWindow
    var childCoordinators = [AnyCoordinator]()
    private let services: UseCaseProvider

    init(window: UIWindow, services: UseCaseProvider) {
        self.window = window
        self.services = services
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        if Unsafe︕！Cache.isWalletConfigured {
            toMain(wallet: Unsafe︕！Cache.wallet!)
        } else {
           toOnboarding()
        }
    }
}


protocol AppNavigator: Navigator {
    func toOnboarding()
    func toMain(wallet: Wallet)
}

// MARK: - AppNavigator
extension AppCoordinator: AppNavigator {

    func toOnboarding() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        start(coordinator: OnboardingCoordinator(navigationController: navigationController, navigator: self, preferences: KeyValueStore(UserDefaults.standard), useCase: services.makeOnboardingUseCase()), mode: .replace)
    }

    func toMain(wallet: Wallet) {
        Unsafe︕！Cache.unsafe︕！Store(wallet: wallet)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        start(coordinator: MainCoordinator(navigationController: navigationController, navigator: self, services: services), mode: .replace)
    }

}
