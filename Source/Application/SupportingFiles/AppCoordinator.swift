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
    private let deepLinkHandler: DeepLinkHandler

    init(window: UIWindow?, deepLinkHandler: DeepLinkHandler, services: UseCaseProvider, securePersistence: SecurePersistence) {
        self.window = window
        self.deepLinkHandler = deepLinkHandler
        self.services = services
        self.securePersistence = securePersistence
        super.init(presenter: nil)
        setupDeepLinkNavigationHandling()
    }

    override func start() {
        if let wallet = securePersistence.wallet {
            toMain(wallet: wallet)
        } else {
            toOnboarding()
        }
    }
}

extension AppCoordinator {
    /// returns: `true` if the delegate successfully handled the request or `false` if the attempt to open the URL resource failed.
    func handleDeepLink(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return deepLinkHandler.handle(url: url, options: options)
    }

    func setupDeepLinkNavigationHandling() {
        let deepLinkStepper = Stepper<DeepLink>()
        deepLinkHandler.set(stepper: deepLinkStepper)
        bag <~ deepLinkStepper.navigationSteps.do(onNext: { [unowned self] in
            switch $0 {
            case .send(let transaction): self.toSend(prefilTransaction: transaction)
            }
        }).drive()
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

        start(coordinator: onboarding, transition: .replace) { [unowned self] in
            switch $0 {
            case .userFinishedChoosing(let wallet): self.toMain(wallet: wallet)
            }
        }
    }

    func toMain(wallet: Wallet) {
        let tabBarController = UITabBarController()
        window?.rootViewController = tabBarController

        let main = MainCoordinator(
            tabBarController: tabBarController,
            deepLinkGenerator: DeepLinkGenerator(),
            services: services,
            securePersistence: securePersistence
        )

        start(coordinator: main, transition: .replace) { [unowned self] in
            switch $0 {
            case .didRemoveWallet: self.toOnboarding()
            }
        }
    }
}

// MARK: Private DeepLink navigation
private extension AppCoordinator {
    func toSend(prefilTransaction transaction: Transaction) {
        guard let mainCoordinator = anyCoordinatorOf(type: MainCoordinator.self) else { return }
        mainCoordinator.toSend(prefilTransaction: transaction)
    }
}
