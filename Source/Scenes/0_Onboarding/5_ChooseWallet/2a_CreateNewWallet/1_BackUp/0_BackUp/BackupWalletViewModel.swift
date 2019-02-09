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
import RxCocoa
import RxSwift
import Zesame

private typealias € = L10n.Scene.BackupWallet

// MARK: - BackupWalletUserAction
enum BackupWalletUserAction {
    case cancel
    case backupWallet
    case revealPrivateKey
    case revealKeystore
}

extension Wallet {
    var keystoreAsJSON: String {
       return keystore.asPrettyPrintedJSONString
    }
}

extension Keystore {
    var asPrettyPrintedJSONString: String {
        guard let keystoreJSON = try? JSONEncoder(outputFormatting: .prettyPrinted).encode(self) else {
            incorrectImplementation("should be able to JSON encode a keystore")
        }
        guard let jsonString = String(data: keystoreJSON, encoding: .utf8) else {
            incorrectImplementation("Should be able to create JSON string from Data")
        }
        return jsonString
    }
}

// MARK: - BackupWalletViewModel
final class BackupWalletViewModel: BaseViewModel<
    BackupWalletUserAction,
    BackupWalletViewModel.InputFromView,
    BackupWalletViewModel.Output
> {

    private let wallet: Driver<Wallet>

    init(wallet: Driver<Wallet>) {
        self.wallet = wallet
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let isUnderstandsRiskCheckboxChecked = input.fromView.isUnderstandsRiskCheckboxChecked

        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            input.fromView.copyKeystoreToPasteboardTrigger.withLatestFrom(wallet.map { $0.keystoreAsJSON }) { $1 }
                .do(onNext: { (keystoreText: String) -> Void in
                    UIPasteboard.general.string = keystoreText
                    input.fromController.toastSubject.onNext(Toast(€.Event.Toast.didCopyKeystore))
                }).drive(),

            input.fromView.revealKeystoreTrigger
                .do(onNext: { userDid(.revealKeystore) })
                .drive(),

            input.fromView.revealPrivateKeyTrigger
                .do(onNext: { userDid(.revealPrivateKey) })
                .drive(),

            input.fromView.doneTrigger.withLatestFrom(isUnderstandsRiskCheckboxChecked)
                .filter { $0 }.mapToVoid()
                .do(onNext: { userDid(.backupWallet) })
                .drive()
        ]

        return Output(
            isDoneButtonEnabled: isUnderstandsRiskCheckboxChecked
        )
    }
}

extension BackupWalletViewModel {

    struct InputFromView {
        let copyKeystoreToPasteboardTrigger: Driver<Void>
        let revealKeystoreTrigger: Driver<Void>
        let revealPrivateKeyTrigger: Driver<Void>
        let isUnderstandsRiskCheckboxChecked: Driver<Bool>
        let doneTrigger: Driver<Void>
    }

    struct Output {
        let isDoneButtonEnabled: Driver<Bool>
    }
}
