//
//  ScanQRCodeViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum ScanQRCodeUserAction: TrackedUserAction {
    case /*user did*/cancel, scanQRContainingTransaction(TransactionIntent)
}

// MARK: - ScanQRCodeViewModel
private typealias € = L10n.Scene.ScanQRCode

final class ScanQRCodeViewModel: BaseViewModel<
    ScanQRCodeUserAction,
    ScanQRCodeViewModel.InputFromView,
    ScanQRCodeViewModel.Output
> {

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let transactionIntent = input.fromView.scannedQrCodeString.map { (qrString) -> TransactionIntent? in
            guard
                let json = qrString.data(using: .utf8),
                let transaction = try? JSONDecoder().decode(TransactionIntent.self, from: json)
                else {
                return nil
            }
            return transaction
        }.filterNil()

        // MARK: Navigate
        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            transactionIntent.do(onNext: { userDid(.scanQRContainingTransaction($0)) })
                .drive()
        ]

        return Output()
    }
}

extension ScanQRCodeViewModel {
    
    struct InputFromView {
        let scannedQrCodeString: Driver<String>
    }

    struct Output {}
}
