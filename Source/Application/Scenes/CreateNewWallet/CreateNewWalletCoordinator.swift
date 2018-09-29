//
//  CreateNewWalletNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class CreateNewWalletCoordinator {

    private weak var navigationController: UINavigationController?
    private weak var navigator: ChooseWalletNavigator?
    private let services: UseCaseProvider

    init(navigationController: UINavigationController?, navigator: ChooseWalletNavigator, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.services = services
    }
}

extension CreateNewWalletCoordinator: AnyCoordinator {
    func start() {
        toCreateWallet()
    }
}

protocol CreateNewWalletNavigator: AnyObject {
    func toCreateWallet()
    func toMain(wallet: Wallet)
}

extension CreateNewWalletCoordinator: CreateNewWalletNavigator {

    func toMain(wallet: Wallet) {
        navigator?.toMain(wallet: wallet)
    }

    func toCreateWallet() {
        let viewModel = CreateNewWalletViewModel(navigator: self, useCase: services.makeChooseWalletUseCase())
        let vc = CreateNewWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
