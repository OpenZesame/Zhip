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

final class AppCoordinator: AbstractCoordinator<AppCoordinator.Step> {
    enum Step {}

    private weak var window: UIWindow?
    private let services: UseCaseProvider
    private let securePersistence: SecurePersistence

    init(window: UIWindow?, services: UseCaseProvider, securePersistence: SecurePersistence) {
        self.window = window
        self.services = services
        self.securePersistence = securePersistence
    }

    override func start() {
        if let wallet = securePersistence.wallet {
            toMain(wallet: wallet)
        } else {
            toOnboarding()
        }
    }
}


// MARK: - Private
private extension AppCoordinator {

    func toOnboarding() {
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController

        let onboarding = OnboardingCoordinator(
            navigationController: navigationController,
            preferences: KeyValueStore(UserDefaults.standard),
            securePersistence: securePersistence,
            useCase: services.makeOnboardingUseCase()
        )

        start(coordinator: onboarding, transition: .replace) { [weak self] in
            switch $0 {
            case .didChoose(let wallet): self?.toMain(wallet: wallet)
            }
        }
    }

    func toMain(wallet: Wallet) {
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController

        let main = MainCoordinator(navigationController: navigationController, services: services, securePersistence: securePersistence)

        start(coordinator: main, transition: .replace) { [weak self] in
            switch $0 {
            case .didRemoveWallet: self?.toOnboarding()
            }
        }
    }
}
