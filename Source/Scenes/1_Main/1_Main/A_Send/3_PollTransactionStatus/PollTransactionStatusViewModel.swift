//
//  PollTransactionStatusViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

import Zesame

import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum PollTransactionStatusUserAction: TrackedUserAction {
    case /*user did*/skip, waitUntilReceipt(TransactionReceipt), waitUntilTimeout
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

        let receipt = useCase.receiptOfTransaction(byId: transactionId, polling: .twentyTimesLinearBackoff)

        // MARK: Navigate
        bag <~ [
            input.fromView.skipWaitingTrigger
                .do(onNext: { userDid(.skip) })
                .drive(),

            receipt.do(
                onNext: { userDid(.waitUntilReceipt($0)) },
                onError: {
                    guard let error = $0 as? Zesame.Error else {
                        incorrectImplementation("Wrong type of error")
                    }
                    if case(.api(.timeout)) = error {
                        userDid(.waitUntilTimeout)
                    } else {
                        log.error("Error: \(error)")
                    }
            }).asDriverOnErrorReturnEmpty().drive()
        ]

        // MARK: Return output
        return Output()
    }
}

extension PollTransactionStatusViewModel {
    
    struct InputFromView {
        let skipWaitingTrigger: Driver<Void>
    }

    struct Output {}
}
