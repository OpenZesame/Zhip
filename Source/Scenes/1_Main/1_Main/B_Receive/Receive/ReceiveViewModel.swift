//
//  ReceiveViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

private typealias € = L10n.Scene.Receive

// MARK: - ReceiveUserAction
enum ReceiveUserAction: TrackableEvent {
    case finish
    case requestTransaction(TransactionIntent)

    // Analytics
    var eventName: String {
        switch self {
        case .finish: return "finish"
        case .requestTransaction: return "requestTransaction"
        }
    }
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

        let amountValidationValue = input.fromView.amountToReceive.map { validator.validateAmount($0) }.startWith(.valid(0))

        let amount = amountValidationValue.map { $0.value }

        let amountValidationTrigger = input.fromView.didEndEditingAmount

        let amountValidation: Driver<AnyValidation> = Driver.merge(
            amountValidationTrigger.withLatestFrom(amountValidationValue).onlyErrors(),
            amountValidationValue.nonErrors()
        )

        let transactionToReceive = Driver.combineLatest(amount.filterNil(), wallet.map { $0.address }) { TransactionIntent(amount: $0, to: $1) }

        let qrImage = transactionToReceive.map { [unowned qrCoder] in
            qrCoder.encode(transaction: $0, size: input.fromView.qrCodeImageHeight)
        }

        let receivingAddress = wallet.map { $0.address.checksummedAddress.asString }

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
            amountBecomeFirstResponder: input.fromController.viewWillAppear,
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
        let amountBecomeFirstResponder: Driver<Void>
        let amountValidation: Driver<AnyValidation>
        let qrImage: Driver<UIImage?>
    }

    struct InputValidator {
        private let amountValidator = AmountValidator()

        func validateAmount(_ amount: String) -> AmountValidator.Result {
            return amountValidator.validate(input: amount)
        }
    }
}
