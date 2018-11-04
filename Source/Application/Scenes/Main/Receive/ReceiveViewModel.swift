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

// MARK: - ReceiveNavigation
enum ReceiveNavigation {}

// MARK: - ReceiveViewModel
final class ReceiveViewModel: AbstractViewModel<
    ReceiveNavigation,
    ReceiveViewModel.InputFromView,
    ReceiveViewModel.Output
> {
    private let wallet: Driver<Wallet>

    init(wallet: Driver<Wallet>) {
        self.wallet = wallet
    }

    override func transform(input: Input) -> Output {

        let receivingAmount = input.fromView.amountToReceive
            .map { Double($0) }
            .filterNil()
            .startWith(0)
            .map { try? Amount(double: $0) }.filterNil()

        let qrImage = Driver.combineLatest(receivingAmount, wallet.map { $0.address }) { QRCoding.Transaction(amount: $0, to: $1) }
            .map { QRCoding.image(of: $0, size: input.fromView.qrCodeImageWidth) }


        let receivingAddress = wallet.map { $0.address.checksummedHex }

        bag <~ [
            input.fromView.copyMyAddressTrigger.withLatestFrom(receivingAddress)
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext("✅ Copied address")
                }).drive(),

            input.fromController.rightBarButtonTrigger.do(onNext: {
                input.fromController.toastSubject.onNext("This will soon be implemented")
            }).drive()
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
