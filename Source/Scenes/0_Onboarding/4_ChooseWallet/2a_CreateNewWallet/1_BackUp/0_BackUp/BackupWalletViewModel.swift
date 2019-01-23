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

import UIKit
import RxCocoa
import RxSwift
import Zesame

private typealias € = L10n.Scene.BackupWallet

// MARK: - BackupWalletUserAction
enum BackupWalletUserAction: String, TrackedUserAction {
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
