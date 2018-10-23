//
//  AppCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame
import KeychainSwift

final class AppCoordinator {

    private let window: UIWindow
    var childCoordinators = [AnyCoordinator]()
    private let services: UseCaseProvider
    private let securePersistence: SecurePersistence

    init(window: UIWindow, services: UseCaseProvider, securePersistence: SecurePersistence) {
        self.window = window
        self.services = services
        self.securePersistence = securePersistence
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        if let wallet = securePersistence.wallet {
            toMain(wallet: wallet)
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
        start(
            coordinator:
            OnboardingCoordinator(
                navigationController: navigationController,
                navigator: self,
                preferences: KeyValueStore(UserDefaults.standard),
                securePersistence: securePersistence,
                useCase: services.makeOnboardingUseCase()
            ),
            mode: .replace
        )
    }

    func toMain(wallet: Wallet) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        start(
            coordinator:
            MainCoordinator(
                navigationController: navigationController,
                navigator: self,
                services: services,
                securePersistence: securePersistence
            ),
            mode: .replace
        )
    }

}
