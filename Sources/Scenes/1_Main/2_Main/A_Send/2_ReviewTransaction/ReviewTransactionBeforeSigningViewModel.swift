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
import RxSwift
import RxCocoa
import Zesame

enum ReviewTransactionBeforeSigningUserAction {
    case acceptPaymentProceedWithSigning(Payment)
}

final class ReviewTransactionBeforeSigningViewModel: BaseViewModel<
    ReviewTransactionBeforeSigningUserAction,
    ReviewTransactionBeforeSigningViewModel.InputFromView,
    ReviewTransactionBeforeSigningViewModel.Output
> {

    private let paymentToReview: Payment

    init(paymentToReview: Payment) {
        self.paymentToReview = paymentToReview
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        // MARK: - Validate input
        bag <~ [
            input.fromView.hasReviewedNowProceedWithSigningTrigger.map { self.paymentToReview }
                .do(onNext: { userDid(.acceptPaymentProceedWithSigning($0)) })
                .drive()
        ]

        let payment = Driver.just(self.paymentToReview)
        let recipientLegacyAddress = payment.map { $0.recipient }
        let recipientBech32Address = payment.map { try? Bech32Address(ethStyleAddress: $0.recipient, network: network) }.filterNil()
        
        let amountFormatter = AmountFormatter()
        
        let amountToPay = payment.map { amountFormatter.format(amount: $0.amount, in: .zil, formatThousands: true, minFractionDigits: 2, showUnit: true) }
        let paymentFee = payment.map { amountFormatter.format(amount: $0.transactionFee, in: .zil, formatThousands: false, minFractionDigits: 5, showUnit: true) }
        let totalCost = payment.map { amountFormatter.format(amount: $0.totalCostInZil, in: .zil, formatThousands: true, minFractionDigits: 2, showUnit: true) }
        
        return Output(
            isHasReviewedNowProceedWithSigningButtonEnabled: input.fromView.isHasReviewedPaymentCheckboxChecked,
            recipientLegacyAddress: recipientLegacyAddress.map { $0.asString },
            recipientBech32Address: recipientBech32Address.map { $0.asString },
            amountToPay: amountToPay,
            paymentFee: paymentFee,
            totalCost: totalCost
        )
    }

}

extension ReviewTransactionBeforeSigningViewModel {

    struct InputFromView {
        let isHasReviewedPaymentCheckboxChecked: Driver<Bool>
        let hasReviewedNowProceedWithSigningTrigger: Driver<Void>
    }

    struct Output {
        let isHasReviewedNowProceedWithSigningButtonEnabled: Driver<Bool>
        let recipientLegacyAddress: Driver<String>
        let recipientBech32Address: Driver<String>
        let amountToPay: Driver<String>
        let paymentFee: Driver<String>
        let totalCost: Driver<String>
    }
}

private extension Payment {
    var transactionFee: Qa {
        return (try? Payment.estimatedTotalTransactionFee(gasPrice: gasPrice, gasLimit: gasLimit)) ?? gasPrice.asQa
    }
    
    var totalCostInZil: ZilAmount {
        if let estimatedTotal = try? Payment.estimatedTotalCostOfTransaction(amount: amount, gasPrice: gasPrice, gasLimit: gasLimit) {
            return estimatedTotal
        } else {
            let totalInQa = amount.asQa + transactionFee
            // swiftlint:disable:next force_try
            return try! ZilAmount(qa: totalInQa)
        }
    }
}
