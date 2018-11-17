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
final class SendCoordinator: BaseCoordinator<SendCoordinator.Step> {
    enum Step {
        case finish
    }

    private let useCaseProvider: UseCaseProvider
    private let deepLinkedTransaction: Driver<Transaction>

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider, deepLinkedTransaction: Driver<Transaction>) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkedTransaction = deepLinkedTransaction
        super.init(presenter: presenter)
        toPrepareTransaction()

    }

    override func start() {}
}

// MARK: - Navigate
private extension SendCoordinator {
    func toPrepareTransaction() {

        let viewModel = PrepareTransactionViewModel(
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            transactionUseCase: useCaseProvider.makeTransactionsUseCase(),
            deepLinkedTransaction: deepLinkedTransaction
        )

        present(type: PrepareTransaction.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .cancel: self.finish()
            case .signPayment(let payment): self.toSignPayment(payment)
            }
        }
    }

    func finish() {
        stepper.step(.finish)
    }

    func toSignPayment(_ payment: Payment) {
        let viewModel = SignTransactionViewModel(
            paymentToSign: payment,
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            transactionUseCase: useCaseProvider.makeTransactionsUseCase()
        )

        present(type: SignTransaction.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .sign(let transactionResponse): self.finish()
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
