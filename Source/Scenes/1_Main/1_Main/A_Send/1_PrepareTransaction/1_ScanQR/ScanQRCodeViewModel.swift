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

// MARK: - User action and navigation steps
enum ScanQRCodeUserAction {
    case /*user did*/cancel, scanQRContainingTransaction(TransactionIntent)
}

// MARK: - ScanQRCodeViewModel
private typealias € = L10n.Scene.ScanQRCode

final class ScanQRCodeViewModel: BaseViewModel<
    ScanQRCodeUserAction,
    ScanQRCodeViewModel.InputFromView,
    ScanQRCodeViewModel.Output
> {
    
    typealias ScannedQRResult = Result<TransactionIntent, Swift.Error>
    
    private let startScanningSubject = BehaviorSubject(value: ())

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let transactionIntentResult: Driver<ScannedQRResult> = input.fromView.scannedQrCodeString.map {
            guard let stringFromQR = $0 else {
                 return ScannedQRResult.failure(TransactionIntent.Error.scannedStringNotAddressNorJson)
            }
    
            do {
                return ScannedQRResult.success(try TransactionIntent.fromScannedQrCodeString(stringFromQR))
            } catch {
                return ScannedQRResult.failure(error)
            }
        }

        // MARK: Navigate
        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            transactionIntentResult.do(onNext: { [unowned self] in
                switch $0 {
                case .failure:
                    let LocalizedToast = €.Event.Toast.IncompatibleQrCode.self
                    let toast = Toast(LocalizedToast.title, dismissing: .manual(dismissButtonTitle: LocalizedToast.dismiss)) {
                        self.startScanningSubject.onNext(())
                    }
                    input.fromController.toastSubject.onNext(toast)
                case .success(let transactionIntent):  userDid(.scanQRContainingTransaction(transactionIntent))
                }
            }).drive()
        ]

        return Output(
            startScanning: startScanningSubject.asDriverOnErrorReturnEmpty()
        )
    }
}

extension ScanQRCodeViewModel {
    
    struct InputFromView {
        let scannedQrCodeString: Driver<String?>
    }

    struct Output {
        let startScanning: Driver<Void>
    }
}
