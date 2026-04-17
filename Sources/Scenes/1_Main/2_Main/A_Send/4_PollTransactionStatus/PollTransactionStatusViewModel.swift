//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Foundation
import UIKit
import Zesame

// MARK: - User action and navigation steps

enum PollTransactionStatusUserAction {
    case /* user did */ skip, dismiss, viewTransactionDetailsInBrowser(id: String), waitUntilTimeout
}

// MARK: - PollTransactionStatusViewModel

final class PollTransactionStatusViewModel: BaseViewModel<
    PollTransactionStatusUserAction,
    PollTransactionStatusViewModel.InputFromView,
    PollTransactionStatusViewModel.Output
> {
    private let useCase: TransactionsUseCase
    private let transactionId: String

    init(useCase: TransactionsUseCase, transactionId: String) {
        self.useCase = useCase
        self.transactionId = transactionId
    }

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let activityTracker = ActivityIndicator()

        let receipt = useCase.receiptOfTransaction(byId: transactionId, polling: .twentyTimesLinearBackoff)
            .trackActivity(activityTracker)
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion,
                   let zError = error as? Zesame.Error,
                   case .api(.timeout) = zError {
                    userDid(.waitUntilTimeout)
                }
            })

        let hasReceivedReceipt: Driver<Bool> = receipt.mapToVoid().asDriverOnErrorReturnEmpty().map { true }.startWith(false).eraseToAnyPublisher()

        // MARK: Navigate

        bag <~ [
            input.fromView.copyTransactionIdTrigger
                .do(onNext: { [unowned self] in
                    UIPasteboard.general.string = transactionId
                    input.fromController.toastSubject
                        .send(Toast(String(localized: .PollTransaction.copiedTransactionId)))
                }).drive(),

            input.fromView.skipWaitingOrDoneTrigger.withLatestFrom(hasReceivedReceipt) { $1 }
                .do(onNext: { hasReceivedReceipt in
                    let action: NavigationStep = hasReceivedReceipt ? .dismiss : .skip
                    userDid(action)

                })
                .drive(),

            input.fromView.seeTxDetails.withLatestFrom(receipt.asDriverOnErrorReturnEmpty()) {
                $1
            }.do(
                onNext: { userDid(.viewTransactionDetailsInBrowser(id: $0.transactionId)) }
            ).drive(),
        ]

        // MARK: Return output

        return Output(
            skipWaitingOrDoneButtonTitle: hasReceivedReceipt
                .map { $0 ? String(localized: .PollTransaction.done) : String(localized: .PollTransaction.skipWaiting) }
                .eraseToAnyPublisher(),
            isSeeTxDetailsEnabled: hasReceivedReceipt,
            isSeeTxDetailsButtonLoading: activityTracker.asDriver()
        )
    }
}

extension PollTransactionStatusViewModel {
    struct InputFromView {
        let copyTransactionIdTrigger: Driver<Void>
        let skipWaitingOrDoneTrigger: Driver<Void>
        let seeTxDetails: Driver<Void>
    }

    struct Output {
        let skipWaitingOrDoneButtonTitle: Driver<String>
        let isSeeTxDetailsEnabled: Driver<Bool>
        let isSeeTxDetailsButtonLoading: Driver<Bool>
    }
}
