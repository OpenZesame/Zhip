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

import Zesame

final class SettingsCoordinator: AnyCoordinator {

    private weak var navigationController: UINavigationController?

    private weak var navigator: AppNavigator?

    private let securePersistence: SecurePersistence

    init(navigationController: UINavigationController?, navigator: AppNavigator, securePersistence: SecurePersistence) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.securePersistence = securePersistence
    }
}

// MARK: - Navigator
extension SettingsCoordinator: SettingsNavigator {

    func toChooseWallet() {
        securePersistence.deleteWallet()
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
