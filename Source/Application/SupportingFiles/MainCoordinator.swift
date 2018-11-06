//
//  MainNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame
import RxCocoa
import RxSwift

final class MainCoordinator: AbstractCoordinator<MainCoordinator.Step> {
    enum Step {
        case didRemoveWallet
    }

    private let tabBarController: UITabBarController

    private let services: UseCaseProvider
    private let securePersistence: SecurePersistence
    private let deepLinkGenerator: DeepLinkGenerator

    init(tabBarController: UITabBarController, deepLinkGenerator: DeepLinkGenerator, services: UseCaseProvider, securePersistence: SecurePersistence) {
        self.services = services
        self.deepLinkGenerator = deepLinkGenerator
        self.securePersistence = securePersistence
        self.tabBarController = tabBarController
        super.init(presenter: nil)
        setupTabBar()
    }

    override func start() {
        tabBarController.selectedIndex = 0
    }
}

// MARK: - Private
private extension MainCoordinator {
    func setupTabBar() {
        let sendNavigationController = UINavigationController(tabBarTitle: "Send")
        let receiveNavigationController = UINavigationController(tabBarTitle: "Receive")
        let settingsNavigationController = UINavigationController(tabBarTitle: "Settings")

        tabBarController.viewControllers = [
            sendNavigationController,
            receiveNavigationController,
            settingsNavigationController
        ]

        let send = SendCoordinator(
            navigationController: sendNavigationController,
            wallet: Driver<Wallet?>.of(securePersistence.wallet).filterNil(),
            services: services
        )

        let receive = ReceiveCoordinator(
            navigationController: receiveNavigationController,
            wallet: Driver<Wallet?>.of(securePersistence.wallet).filterNil(),
            deepLinkGenerator: deepLinkGenerator
        )

        let settings = SettingsCoordinator(
            navigationController: settingsNavigationController,
            securePersistence: securePersistence
        )

        start(coordinator: send, transition: .doNothing) {
            switch $0 {} // nothing to do yet
        }

        start(coordinator: receive, transition: .doNothing) {
            switch $0 {}
        }

        start(coordinator: settings, transition: .doNothing) { [unowned stepper] in
            switch $0 {
            case .walletWasRemovedByUser: stepper.step(.didRemoveWallet)
            }
        }

        childCoordinators = [send, receive, settings]
    }
}

// MARK: - Deep Link Navigation
extension MainCoordinator {

    func toSend(prefilTransaction transaction: Transaction) {
        tabBarController.selectedIndex = 0
        guard let sendCoordinator = anyCoordinatorOf(type: SendCoordinator.self) else { return }
        sendCoordinator.toSend(prefilTransaction: transaction)
    }
}
