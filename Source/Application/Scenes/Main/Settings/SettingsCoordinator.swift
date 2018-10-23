//
//  SettingsCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SettingsNavigator: AnyObject {
    func toSettings()
    func toChooseWallet()
}

final class SettingsCoordinator: AnyCoordinator {

    private weak var navigationController: UINavigationController?

    private weak var navigator: AppNavigator?

    init(navigationController: UINavigationController?, navigator: AppNavigator) {
        self.navigationController = navigationController
        self.navigator = navigator
    }
}

// MARK: - Navigator
extension SettingsCoordinator: SettingsNavigator {

    func toChooseWallet() {
        Unsafe︕！Cache.deleteWallet()
//        navigator?.toChooseWallet()
        navigator?.toOnboarding()
    }

    func start() {
        toSettings()
    }

    func toSettings() {
        navigationController?.pushViewController(
            Settings(
                viewModel: SettingsViewModel(navigator: self)
            ),
            animated: true
        )
    }
}
