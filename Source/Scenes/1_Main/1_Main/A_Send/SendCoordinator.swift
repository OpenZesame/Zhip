//
//  SendCoordinator.swifr
//  Zhip
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
        case finish(fetchBalance: Bool)
    }

    private let useCaseProvider: UseCaseProvider
    private let transactionIntent: Driver<TransactionIntent>
    private let scannedQRTransactionSubject = PublishSubject<TransactionIntent>()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, deeplinkedTransaction: Driver<TransactionIntent>) {
        self.useCaseProvider = useCaseProvider
        self.transactionIntent = Driver.merge(deeplinkedTransaction, scannedQRTransactionSubject.asDriverOnErrorReturnEmpty())
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toFirst()
    }
}

// MARK: - Navigate
private extension SendCoordinator {

    func toFirst() {
        guard useCaseProvider.makeOnboardingUseCase().hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        toPrepareTransaction()
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(useCase: useCaseProvider.makeOnboardingUseCase())

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understandRisks: self.toPrepareTransaction()
            }
        }
    }

    func toPrepareTransaction() {
        let viewModel = PrepareTransactionViewModel(
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            transactionUseCase: useCaseProvider.makeTransactionsUseCase(),
            scannedOrDeeplinkedTransaction: transactionIntent.filter { [unowned self] _ in
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
            case .scanQRCode: self.toScanQRCode()
            case .signPayment(let payment): self.toSignPayment(payment)
            }
        }
    }

    func toScanQRCode() {
        modallyPresent(scene: ScanQRCode.self, viewModel: ScanQRCodeViewModel()) { [unowned self] userDid, dismissScene in
            switch userDid {
            case .scanQRContainingTransaction(let transaction):
                dismissScene(true) {
                    self.scannedQRTransactionSubject.onNext(transaction)
                }
            case .cancel:
                dismissScene(true, nil)
            }
        }
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
                self.toWaitForReceiptForTransactionWith(id: transactionResponse.transactionIdentifier)
            }
        }
    }

    func toWaitForReceiptForTransactionWith(id transactionId: String) {
        let viewModel = PollTransactionStatusViewModel(
            useCase: useCaseProvider.makeTransactionsUseCase(),
            transactionId: transactionId
        )

        push(scene: PollTransactionStatus.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .skip, .waitUntilTimeout: self.finish()
            case .dismiss: self.finish(triggerBalanceFetching: true)
            case .viewTransactionDetailsInBrowser(let txId): self.openInBrowserDetailsForTransaction(id: txId)
            }
        }
    }

    func openInBrowserDetailsForTransaction(id transactionId: String) {
        let baseURL = "https://explorer.zilliqa.com/"
        guard let url = URL(string: "transactions/\(transactionId)", relativeTo: URL(string: baseURL)) else {
            return log.error("failed to create url")
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func finish(triggerBalanceFetching: Bool = false) {
        navigator.next(.finish(fetchBalance: triggerBalanceFetching))
    }

}
