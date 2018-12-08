//
//  SendCoordinator.swifr
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

// MARK: - SendCoordinator
final class SendCoordinator: BaseCoordinator<SendCoordinator.NavigationStep> {
    enum NavigationStep {
        case finish
    }

    private let useCaseProvider: UseCaseProvider
    private let deeplinkedTransaction: Driver<Transaction>

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, deeplinkedTransaction: Driver<Transaction>) {
        self.useCaseProvider = useCaseProvider
        self.deeplinkedTransaction = deeplinkedTransaction
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toPrepareTransaction()
    }
}

// MARK: - Navigate
private extension SendCoordinator {
    func toPrepareTransaction() {
        let viewModel = PrepareTransactionViewModel(
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            transactionUseCase: useCaseProvider.makeTransactionsUseCase(),
            deepLinkedTransaction: deeplinkedTransaction.filter { [unowned self] _ in
                let prepareTransactionIsCurrentScene = self.navigationController.viewControllers.isEmpty || self.isTopmost(scene: PrepareTransaction.self)
                guard prepareTransactionIsCurrentScene else {
                    log.verbose("Prevented deeplinked transaction since it is not the active scene.")
                    return false
                }
                return true
            }
        )

        push(scene: PrepareTransaction.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .cancel: self.finish()
            case .signPayment(let payment): self.toSignPayment(payment)
            }
        }
    }

    func finish() {
        navigator.next(.finish)
    }

    func toSignPayment(_ payment: Payment) {
        let viewModel = SignTransactionViewModel(
            paymentToSign: payment,
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            transactionUseCase: useCaseProvider.makeTransactionsUseCase()
        )

        push(scene: SignTransaction.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .sign(let transactionResponse):
                log.info("Doing nothing with tx with id \(transactionResponse.transactionIdentifier)")
                self.finish()
            }
        }
    }

//    // TODO extract this to its own type?
//    func toTransaction(viewTxDetailsFor transactionId: String) {
//        let baseURL = "https://dev-test-explorer.aws.z7a.xyz/"
//        guard let url = URL(string: "transactions/\(transactionId)", relativeTo: URL(string: baseURL)) else {
//            return log.error("failed to create url")
//        }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }
}
