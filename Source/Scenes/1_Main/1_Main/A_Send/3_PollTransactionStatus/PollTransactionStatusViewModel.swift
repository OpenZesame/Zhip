//
//  PollTransactionStatusViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
		let skipWaitingOrDoneTrigger: Driver<Void>
		let seeTxDetails: Driver<Void>
	}

	struct Output {
		let skipWaitingOrDoneButtonTitle: Driver<String>
		let isSeeTxDetailsEnabled: Driver<Bool>
		let isSeeTxDetailsButtonLoading: Driver<Bool>
	}
}
