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
    private let useCase: ChooseWalletUseCase

    init(navigationController: UINavigationController?, navigator: ChooseWalletNavigator, useCase: ChooseWalletUseCase) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.useCase = useCase
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
        let viewModel = CreateNewWalletViewModel(navigator: self, useCase: useCase)
        let vc = CreateNewWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
