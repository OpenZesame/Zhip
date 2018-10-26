//
//  ReceiveNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - ReceiveNavigator
final class ReceiveCoordinator {

    private weak var navigationController: UINavigationController?
    private let wallet: Driver<Wallet>
//    private let services: UseCaseProvider

    init(navigationController: UINavigationController, wallet: Driver<Wallet>) {
        self.navigationController = navigationController
        self.wallet = wallet
//        self.services = services
    }
}

extension ReceiveCoordinator: AnyCoordinator {
    func start() {
        toReceive()
    }
}

protocol ReceiveNavigator: AnyObject {
    func toReceive()
}

extension ReceiveCoordinator: ReceiveNavigator {

    func toReceive() {
        navigationController?.pushViewController(
            Receive(
                viewModel: ReceiveViewModel(wallet: wallet)
            ),
            animated: false
        )
    }
}
