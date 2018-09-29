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

    private weak var navigation: AppNavigation?

    init(navigationController: UINavigationController?, navigation: AppNavigation) {
        self.navigationController = navigationController
        self.navigation = navigation
    }
}

// MARK: - Navigator
extension SettingsCoordinator: SettingsNavigator {

    func toChooseWallet() {
        Unsafe︕！Cache.deleteWallet()
        navigation?.toChooseWallet()
    }

    func start() {
        toSettings()
    }

    func toSettings() {
        navigationController?.pushViewController(
            Settings(
                viewModel: SettingsViewModel(navigation: self)
            ),
            animated: true
        )
    }
}
