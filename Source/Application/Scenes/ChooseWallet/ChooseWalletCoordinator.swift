//
//  ChooseWalletNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import Zesame

final class ChooseWalletCoordinator: Coordinator {

    private weak var navigationController: UINavigationController?
    private weak var navigation: AppNavigation?
    private let services: UseCaseProvider

    var childCoordinators = [AnyCoordinator]()

    init(navigationController: UINavigationController, navigation: AppNavigation, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.navigation = navigation
        self.services = services
    }
}

extension ChooseWalletCoordinator {

    func start() {
        toChooseWallet()
    }
}

protocol ChooseWalletNavigator: AnyObject {
    func toMain(wallet: Wallet)
    func toChooseWallet()
    func toCreateNewWallet()
    func toRestoreWallet()
}

extension ChooseWalletCoordinator: ChooseWalletNavigator {

    func toMain(wallet: Wallet) {
        navigation?.toMain(wallet: wallet)
    }

    func toChooseWallet() {
        let viewModel = ChooseWalletViewModel(navigator: self)
        let vc = ChooseWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func toCreateNewWallet() {
        start(coordinator: CreateNewWalletCoordinator(navigationController: navigationController, navigator: self, services: services))
    }

    func toRestoreWallet() {
        start(coordinator: RestoreWalletCoordinator(navigationController: navigationController, navigator: self, services: services))
    }

}
