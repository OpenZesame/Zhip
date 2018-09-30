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
    private let useCase: ChooseWalletUseCase

    init(navigationController: UINavigationController?, navigator: ChooseWalletNavigator, useCase: ChooseWalletUseCase) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.useCase = useCase
    }
}

extension RestoreWalletCoordinator: AnyCoordinator {

    func start() {
        toRestoreWallet()
    }

}

/// Used for Navigation between Coordinators
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
        let viewModel = RestoreWalletViewModel(navigator: self, useCase: useCase)
        let vc = RestoreWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
