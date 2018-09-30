//
//  SendNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - SendNavigator
final class SendCoordinator {

    private weak var navigationController: UINavigationController?
    private let wallet: Wallet
    private let services: UseCaseProvider

    init(navigationController: UINavigationController, wallet: Wallet, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.wallet = wallet
        self.services = services
    }
}

extension SendCoordinator: AnyCoordinator {
    func start() {
        toSend()
    }
}

protocol SendNavigator: AnyObject {
    func toSend()
}

extension SendCoordinator: SendNavigator {

    func toSend() {
        navigationController?.pushViewController(
            Send(
                viewModel: SendViewModel(navigator: self, wallet: wallet, useCase: services.makeTransactionsUseCase())
            ),
            animated: true
        )
    }
}
