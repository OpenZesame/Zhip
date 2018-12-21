//
//  GotTransactionReceiptViewModel.swift
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
enum GotTransactionReceiptUserAction: TrackedUserAction {
    case /*user intends to*/ finish, viewTransactionDetailsInBrowser(id: String)
}

// MARK: - GotTransactionReceiptViewModel
private typealias € = L10n.Scene.GotTransactionReceipt

final class GotTransactionReceiptViewModel: BaseViewModel<
    GotTransactionReceiptUserAction,
    GotTransactionReceiptViewModel.InputFromView,
    GotTransactionReceiptViewModel.Output
> {
    private let receipt: TransactionReceipt

    init(receipt: TransactionReceipt) {
        self.receipt = receipt
    }

    override func transform(input: Input) -> Output {
        func userIntends(to userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let txId = receipt.transactionId

        // MARK: Navigate
        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .finish) })
                .drive(),

            input.fromView.openDetailsInBrowserTrigger
                .do(onNext: { userIntends(to: .viewTransactionDetailsInBrowser(id: txId)) })
                .drive()
        ]

        // MARK: Format output
        let transactionFee = Driver.just(receipt.totalGasCost).map {
            €.Labels.Fee.value($0.description)
        }

        return Output(
            transactionFee: transactionFee
        )
    }
}

extension GotTransactionReceiptViewModel {
    
    struct InputFromView {
        let openDetailsInBrowserTrigger: Driver<Void>
    }

    struct Output {
        let transactionFee: Driver<String>
    }
}
