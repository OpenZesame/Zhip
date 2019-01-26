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

import Foundation

import Zesame

import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum PollTransactionStatusUserAction: TrackableEvent {
	case /*user did*/skip, dismiss, viewTransactionDetailsInBrowser(id: String), waitUntilTimeout

    // Analytics
    var eventName: String {
        switch self {
        case .skip: return "skip"
        case .dismiss: return "dismss"
        case .viewTransactionDetailsInBrowser: return "viewTransactionDetailsInBrowser"
        case .waitUntilTimeout: return "waitUntilTimeout"
        }
    }
}

// MARK: - PollTransactionStatusViewModel
private typealias € = L10n.Scene.PollTransactionStatus

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

	// swiftlint:disable:next function_body_length
	override func transform(input: Input) -> Output {
		func userDid(_ userAction: NavigationStep) {
			navigator.next(userAction)
		}

		let activityTracker = ActivityIndicator()

		let receipt = useCase.receiptOfTransaction(byId: transactionId, polling: .twentyTimesLinearBackoff)
			.trackActivity(activityTracker)
			.do(onError: {
				guard let error = $0 as? Zesame.Error else {
					incorrectImplementation("Wrong type of error")
				}
				if case(.api(.timeout)) = error {
					userDid(.waitUntilTimeout)
				}
			}
		)

		let hasReceivedReceipt = receipt.mapToVoid().asDriverOnErrorReturnEmpty().map { true }.startWith(false)

		// MARK: Navigate
		bag <~ [
            input.fromView.copyTransactionIdTrigger
                .do(onNext: { [unowned self] in
                    UIPasteboard.general.string = self.transactionId
                    input.fromController.toastSubject.onNext(Toast(€.Event.Toast.didCopyTransactionId))
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
				).drive()
		]

		// MARK: Return output

		return Output(
			skipWaitingOrDoneButtonTitle: hasReceivedReceipt.map { $0 ? €.Button.SkipWaitingOrDone.done : €.Button.SkipWaitingOrDone.skip },
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
