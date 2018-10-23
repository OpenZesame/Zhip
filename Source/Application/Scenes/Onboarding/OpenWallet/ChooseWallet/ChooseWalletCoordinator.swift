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
    private weak var navigator: OnboardingNavigator?
    private let useCase: ChooseWalletUseCase

    var childCoordinators = [AnyCoordinator]()

    init(navigationController: UINavigationController, navigator: OnboardingNavigator, useCase: ChooseWalletUseCase) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.useCase = useCase
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
        navigator?.toMain(wallet: wallet)
    }

    func toChooseWallet() {
        let viewModel = ChooseWalletViewModel(navigator: self)
        let vc = ChooseWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func toCreateNewWallet() {
        start(coordinator: CreateNewWalletCoordinator(navigationController: navigationController, navigator: self, useCase: useCase))
    }

    func toRestoreWallet() {
        start(coordinator: RestoreWalletCoordinator(navigationController: navigationController, navigator: self, useCase: useCase))
    }

}
