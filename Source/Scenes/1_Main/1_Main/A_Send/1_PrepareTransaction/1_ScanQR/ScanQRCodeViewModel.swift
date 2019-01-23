//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - User action and navigation steps
enum ScanQRCodeUserAction: TrackableEvent {
    case /*user did*/cancel, scanQRContainingTransaction(TransactionIntent)

    // Analytics
    var eventName: String {
        switch self {
        case .cancel: return "cancel"
        case .scanQRContainingTransaction: return "scanQRContainingTransaction"
        }
    }
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
