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

    init(window: UIWindow) {
        self.window = window
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
        let chooseWalletCoordinator = ChooseWalletCoordinator(navigationController: navigationController, navigation: self)
        childCoordinators = [chooseWalletCoordinator]
        chooseWalletCoordinator.start()
    }

    func toMain(wallet: Wallet) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        let mainCoordinator = MainCoordinator(navigationController: navigationController, wallet: wallet, navigation: self)
        childCoordinators = [mainCoordinator]
        mainCoordinator.start()
    }
}
