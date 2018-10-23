//
//  RestoreWalletNavigator.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class RestoreWalletCoordinator: AnyCoordinator {

    private weak var navigationController: UINavigationController?
    private weak var navigator: ChooseWalletNavigator?

    init(navigationController: UINavigationController?, navigator: ChooseWalletNavigator) {
        self.navigationController = navigationController
        self.navigator = navigator
    }
}

public protocol RestoreWalletNavigator: AnyObject {
    func toRestoreWallet()
    func toMain(restoredWallet: Wallet)
}

// MARK: - Navigator
extension RestoreWalletCoordinator: RestoreWalletNavigator {

    func toMain(restoredWallet: Wallet) {
        navigator?.toMain(wallet: restoredWallet)
    }

    func toRestoreWallet() {
        let viewModel = RestoreWalletViewModel(navigator: self, service: DefaultZilliqaService.shared.rx)
        let vc = RestoreWallet(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func start() {
        toRestoreWallet()
    }
}
