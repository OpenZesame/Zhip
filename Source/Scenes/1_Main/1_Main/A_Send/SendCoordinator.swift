// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
    private let onboardingUseCase: OnboardingUseCase
    private let transactionIntent: Driver<TransactionIntent>
    private let scannedQRTransactionSubject = PublishSubject<TransactionIntent>()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, deeplinkedTransaction: Driver<TransactionIntent>) {
        self.useCaseProvider = useCaseProvider
        self.onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
        
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
        let viewModel = WarningERC20ViewModel(
            useCase: onboardingUseCase,
            mode: .userHaveToAccept(isDoNotShowAgainButtonVisible: true)
        )

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understandRisks, .dismiss: self.toPrepareTransaction()
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
                    // Prevented deeplinked transaction since it is not the active scene
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
        let urlString = "transactions/\(transactionId)"
        guard let url = URL(string: urlString, relativeTo: URL(string: baseURL)) else {
            GlobalTracker.shared.track(error: .failedToCreateUrl(from: baseURL))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func finish(triggerBalanceFetching: Bool = false) {
        navigator.next(.finish(fetchBalance: triggerBalanceFetching))
    }

}
