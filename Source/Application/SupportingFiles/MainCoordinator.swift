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
        case walletWasRemovedByUser
    }

    private let tabBarController = UITabBarController()


    private let services: UseCaseProvider
    private let securePersistence: SecurePersistence

    init(navigationController: UINavigationController, services: UseCaseProvider, securePersistence: SecurePersistence) {
        self.services = services
        self.securePersistence = securePersistence
        super.init(navigationController: navigationController)
        setupTabBar()
    }

    override func start() {
        toSend()
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
            wallet: Driver<Wallet?>.of(securePersistence.wallet).filterNil()
        )

        let settings = SettingsCoordinator(
            navigationController: settingsNavigationController,
            securePersistence: securePersistence
        )

        start(coordinator: send, transition: .doNothing) {
            switch $0 {} // nothing to do yet
        }

        start(coordinator: receive, transition: .doNothing) {
            switch $0 {} // nothing to do yet
        }

        start(coordinator: settings, transition: .doNothing) { [unowned stepper] in
            switch $0 {
            case .walletWasRemovedByUser: stepper.step(.walletWasRemovedByUser)
            }
        }

        childCoordinators = [send, receive, settings]

        navigationController.pushViewController(tabBarController, animated: false)
    }
}

// MARK: - Navigation
private extension MainCoordinator {

    func toSend() {
        tabBarController.selectedIndex = 0
    }

    func toReceive() {
        tabBarController.selectedIndex = 1
    }

    func toSettings() {
        tabBarController.selectedIndex = 2
    }
}
