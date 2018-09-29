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
           toChooseWallet()
        }
    }
}

protocol AppNavigation: AnyObject {
    func toChooseWallet()
    func toMain(wallet: Wallet)
}

// MARK: - Private
extension AppCoordinator: AppNavigation {
    func toChooseWallet() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController


        let chooseWalletCoordinator = ChooseWalletCoordinator(navigationController: navigationController, navigation: self, services: services)
        childCoordinators = [chooseWalletCoordinator]
        chooseWalletCoordinator.start()
    }

    func toMain(wallet: Wallet) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        let mainCoordinator = MainCoordinator(navigationController: navigationController, wallet: wallet, navigation: self, services: services)
        childCoordinators = [mainCoordinator]
        mainCoordinator.start()
    }
}
