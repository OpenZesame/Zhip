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

private typealias € = L10n.Scene.Receive

// MARK: - ReceiveUserAction
enum ReceiveUserAction {
    case finish
    case requestTransaction(TransactionIntent)
}

// MARK: - ReceiveViewModel
final class ReceiveViewModel: BaseViewModel<
    ReceiveUserAction,
    ReceiveViewModel.InputFromView,
    ReceiveViewModel.Output
> {

    private let useCase: WalletUseCase
    private let qrCoder: QRCoding

    init(useCase: WalletUseCase, qrCoder: QRCoding = QRCoder()) {
        self.useCase = useCase
        self.qrCoder = qrCoder

    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let wallet = useCase.wallet.filterNil().asDriverOnErrorReturnEmpty()

        let validator = InputValidator()

        let amountValidationValue: Driver<AmountValidator<ZilAmount>.ValidationResult> = input.fromView.amountToReceive.map { validator.validateAmount($0) }.startWith(.valid(.amount(0, in: .zil)))

        let amount = amountValidationValue.map { $0.value }

        let amountValidationTrigger = input.fromView.didEndEditingAmount

        let amountValidation: Driver<AnyValidation> = Driver.merge(
            amountValidationTrigger.withLatestFrom(amountValidationValue).onlyErrors(),
            amountValidationValue.nonErrors()
        )

        let transactionToReceive = Driver.combineLatest(
            wallet.map { Address.bech32($0.bech32Address) },
            amount.map { $0?.amount }.filterNil()
        ) { TransactionIntent(to: $0, amount: $1) }

        let qrImage = transactionToReceive.map { [unowned qrCoder] in
            qrCoder.encode(transaction: $0, size: input.fromView.qrCodeImageHeight)
        }

        let receivingAddress = wallet.map { $0.bech32Address.asString }

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.finish) })
                .drive(),

            input.fromView.copyMyAddressTrigger.withLatestFrom(receivingAddress)
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext(Toast(€.Event.Toast.didCopyAddress))
                }).drive(),

            input.fromView.shareTrigger.withLatestFrom(transactionToReceive)
                .do(onNext: { userDid(.requestTransaction($0)) })
                .drive()
        ]
        
        return Output(
            receivingAddress: receivingAddress,
            amountPlaceholder: Driver.just(€.Field.requestAmount(Unit.zil.name)),
            amountValidation: amountValidation,
            qrImage: qrImage
        )
    }
}

extension ReceiveViewModel {

    struct InputFromView {
        let qrCodeImageHeight: CGFloat
        let amountToReceive: Driver<String>
        let didEndEditingAmount: Driver<Void>
        let copyMyAddressTrigger: Driver<Void>
        let shareTrigger: Driver<Void>
    }

    struct Output {
        let receivingAddress: Driver<String>
        let amountPlaceholder: Driver<String>
        let amountValidation: Driver<AnyValidation>
        let qrImage: Driver<UIImage?>
    }

    struct InputValidator {
        private let zilAmountValidator = AmountValidator<ZilAmount>()

        func validateAmount(_ amount: String) -> AmountValidator<ZilAmount>.ValidationResult {
            return zilAmountValidator.validate(input: (amount, Zesame.Unit.zil))
        }
    }
}
