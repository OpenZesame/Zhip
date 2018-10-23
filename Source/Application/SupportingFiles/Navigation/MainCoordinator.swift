//
//  MainNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class MainCoordinator: Coordinator {

    private weak var navigationController: UINavigationController?
    private let tabBarController = UITabBarController()

    var childCoordinators = [AnyCoordinator]()

    private let services: UseCaseProvider
    private weak var navigator: AppNavigator?

    init(navigationController: UINavigationController, navigator: AppNavigator, services: UseCaseProvider) {
        self.navigator = navigator
        self.navigationController = navigationController
        self.services = services

        // SEND
        let sendNavigationController = UINavigationController()
        sendNavigationController.tabBarItem = UITabBarItem("Send")
        start(coordinator: SendCoordinator(navigationController: sendNavigationController, wallet: Unsafe︕！Cache.wallet!, services: services))

        // SETTINGS
        let settingsNavigationController = UINavigationController()
        settingsNavigationController.tabBarItem = UITabBarItem("Settings")
        start(coordinator: SettingsCoordinator(navigationController: settingsNavigationController, navigator: navigator))

        tabBarController.viewControllers = [
            sendNavigationController,
            settingsNavigationController
        ]

        navigationController.pushViewController(tabBarController, animated: false)
    }
}

extension MainCoordinator {
    func start() {
        toSend()
    }
}

protocol MainNavigator: AnyObject {
    func toSend()
    func toSettings()
}

// MARK: - Conformance: Navigator
extension MainCoordinator: MainNavigator {

    func toSend() {
        tabBarController.selectedIndex = 0
    }

    func toSettings() {
        tabBarController.selectedIndex = 1
    }
}
