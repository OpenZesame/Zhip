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
final class SendCoordinator: AbstractCoordinator<SendCoordinator.Step> {
    enum Step {}

    private let wallet: Driver<Wallet>
    private let services: UseCaseProvider

    init(navigationController: UINavigationController, wallet: Driver<Wallet>, services: UseCaseProvider) {
        self.wallet = wallet
        self.services = services
        super.init(presenter: navigationController)
    }

    override func start() {
        toSend()
    }
}

private extension SendCoordinator {

    func toSend() {
        present(type: Send.self, viewModel: SendViewModel(wallet: wallet, useCase: services.makeTransactionsUseCase())) {
            switch $0 {
            case .userInitiatedTransaction: break;
            }
        }
    }
}
