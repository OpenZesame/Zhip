//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Foundation

// MARK: - User action and navigation steps

enum ScanQRCodeUserAction {
    case /* user did */ cancel, scanQRContainingTransaction(TransactionIntent)
}

// MARK: - ScanQRCodeViewModel

final class ScanQRCodeViewModel: BaseViewModel<
    ScanQRCodeUserAction,
    ScanQRCodeViewModel.InputFromView,
    ScanQRCodeViewModel.Output
> {
    typealias ScannedQRResult = Result<TransactionIntent, Swift.Error>

    private let startScanningSubject = CurrentValueSubject<Void, Never>(())

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let transactionIntentResult: AnyPublisher<ScannedQRResult, Never> = input.fromView.scannedQrCodeString.map {
            guard var stringFromQR = $0 else {
                return ScannedQRResult.failure(TransactionIntent.Error.scannedStringNotAddressNorJson)
            }

            let zilliqaPrefix = "zilliqa://"
            if stringFromQR.starts(with: zilliqaPrefix) {
                stringFromQR = String(stringFromQR.dropFirst(zilliqaPrefix.count))
            }

            do {
                return try ScannedQRResult.success(TransactionIntent.fromScannedQrCodeString(stringFromQR))
            } catch {
                return ScannedQRResult.failure(error)
            }
        }.eraseToAnyPublisher()

        // MARK: Navigate

        [
            input.fromController.leftBarButtonTrigger
                .sink { userDid(.cancel) },

            transactionIntentResult.sink { [unowned self] in
                switch $0 {
                case .failure:
                    let toast = Toast(
                        String(localized: .ScanQRCode.incompatibleQRTitle),
                        dismissing: .manual(dismissButtonTitle: String(localized: .ScanQRCode.dismiss))
                    ) {
                        self.startScanningSubject.send(())
                    }
                    input.fromController.toastSubject.send(toast)
                case let .success(transactionIntent): userDid(.scanQRContainingTransaction(transactionIntent))
                }
            },
        ].forEach { $0.store(in: &cancellables) }

        return Output(
            startScanning: startScanningSubject.replaceErrorWithEmpty()
        )
    }
}

extension ScanQRCodeViewModel {
    struct InputFromView {
        let scannedQrCodeString: AnyPublisher<String?, Never>
    }

    struct Output {
        let startScanning: AnyPublisher<Void, Never>
    }
}
