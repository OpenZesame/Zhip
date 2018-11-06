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
    private let deepLinkTransactionSubject = PublishSubject<Transaction>()

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

        let viewModel = SendViewModel(
            wallet: wallet,
            useCase: services.makeTransactionsUseCase(),
            deepLinkedTransaction: deepLinkTransactionSubject.asObservable()
        )

        present(type: Send.self, viewModel: viewModel) {
            switch $0 {
            case .userInitiatedTransaction: break;
            }
        }
    }
}

extension SendCoordinator {

    func toSend(prefilTransaction transaction: Transaction?) {
        if let transaction = transaction {
            deepLinkTransactionSubject.onNext(transaction)
            // Right now we only have the Send Scene in this coordinator, so no need to focus the ViewController.
        } else {
            toSend()
        }
    }
}
