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

    private let useCaseProvider: UseCaseProvider
    private let deepLinkTransactionSubject = PublishSubject<Transaction>()

    init(presenter: Presenter, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
    }

    override func start() {
        toSend()
    }
}

// MARK: DeepLinking
internal extension SendCoordinator {

    func toSend(prefilTransaction transaction: Transaction?) {
        if let transaction = transaction {
            deepLinkTransactionSubject.onNext(transaction)
            // Right now we only have the Send Scene in this coordinator, so no need to focus the ViewController.
        } else {
            toSend()
        }
    }
}

// MARK: - Navigate
private extension SendCoordinator {
    func toSend() {

        let viewModel = SendViewModel(
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            transactionUseCase: useCaseProvider.makeTransactionsUseCase(),
            deepLinkedTransaction: deepLinkTransactionSubject.asObservable()
        )

        present(type: Send.self, viewModel: viewModel) { [unowned self] in
            switch $0 {
            case .userInitiatedTransaction: break;
            case .userSelectedSeeTransactionDetailsInBrowser(let transactionId): self.openBrowser(viewTxDetailsFor: transactionId)

            }
        }
    }

    // TODO extract this to its own type?
    func openBrowser(viewTxDetailsFor transactionId: String) {
        let baseURL = "https://dev-test-explorer.aws.z7a.xyz/"
        guard let url = URL(string: "transactions/\(transactionId)", relativeTo: URL(string: baseURL)) else {
            return log.error("failed to create url")
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
