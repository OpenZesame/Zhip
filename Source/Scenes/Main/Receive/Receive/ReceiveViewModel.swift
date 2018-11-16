//
//  ReceiveViewModel.swift
//  Zupreme
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
enum ReceiveUserAction: TrackedUserAction {
    case requestTransaction(Transaction)
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
        func userDid(_ userAction: Step) {
            stepper.step(userAction)
        }

        let wallet = useCase.wallet.filterNil().asDriverOnErrorReturnEmpty()

        let receivingAmount = input.fromView.amountToReceive
            .map { Double($0) }
            .filterNil()
            .startWith(0)
            .map { try? Amount(double: $0) }.filterNil()

        let transactionToReceive = Driver.combineLatest(receivingAmount, wallet.map { $0.address }) { Transaction(amount: $0, to: $1) }

        let qrImage = transactionToReceive.map { [unowned qrCoder] in
            qrCoder.encode(transaction: $0, size: input.fromView.qrCodeImageWidth)
        }

        let receivingAddress = wallet.map { $0.address.checksummedHex }

        bag <~ [
            input.fromView.copyMyAddressTrigger.withLatestFrom(receivingAddress)
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext(Toast("✅ " + €.Event.Toast.didCopyAddress))
                }).drive(),

            input.fromController.rightBarButtonTrigger.withLatestFrom(transactionToReceive)
                .do(onNext: { userDid(.requestTransaction($0)) })
                .drive()
        ]

        return Output(
            receivingAddress: receivingAddress,
            qrImage: qrImage
        )
    }
}

extension ReceiveViewModel {

    struct InputFromView {
        let copyMyAddressTrigger: Driver<Void>
        let qrCodeImageWidth: CGFloat
        let amountToReceive: Driver<String>
    }

    struct Output {
        let receivingAddress: Driver<String>
        let qrImage: Driver<UIImage?>
    }
}
