//
//  RestoreWalletNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class RestoreWalletCoordinator {

    private weak var navigationController: UINavigationController?
    private weak var navigator: ChooseWalletNavigator?
    private let services: UseCaseProvider

    init(navigationController: UINavigationController?, navigator: ChooseWalletNavigator, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.services = services
    }
}

extension RestoreWalletCoordinator: AnyCoordinator {

    func start() {
        toRestoreWallet()
    }

}

protocol Navigator: AnyObject {}
protocol RestoreWalletNavigator: Navigator {
    func toRestoreWallet()
    func toMain(restoredWallet: Wallet)
}

// MARK: - Navigator
extension RestoreWalletCoordinator: RestoreWalletNavigator {

    func toMain(restoredWallet: Wallet) {
        navigator?.toMain(wallet: restoredWallet)
    }

    func toRestoreWallet() {
        let viewModel = RestoreWalletViewModel(navigator: self, useCase: services.makeChooseWalletUseCase())
        let vc = RestoreWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
