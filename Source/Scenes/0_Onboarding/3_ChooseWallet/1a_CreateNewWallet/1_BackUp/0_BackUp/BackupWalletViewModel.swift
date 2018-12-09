//
//  BackupWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Zesame

private typealias € = L10n.Scene.BackupWallet

// MARK: - BackupWalletUserAction
enum BackupWalletUserAction: TrackedUserAction {
    case abort
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
    private let isDismissable: Bool

    init(wallet: Driver<Wallet>, isDismissable: Bool) {
        self.wallet = wallet
        self.isDismissable = isDismissable
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }
        let isUnderstandsRiskCheckboxChecked = input.fromView.isUnderstandsRiskCheckboxChecked

        if isDismissable {
            input.fromController.rightBarButtonContentSubject.onNext(BarButton.done.content)
            bag <~ input.fromController.rightBarButtonTrigger.do(onNext: {
                userDid(.abort)
            }).drive()
        }

        bag <~ [
            input.fromView.copyKeystoreToPasteboardTrigger.withLatestFrom(wallet.map { $0.keystoreAsJSON }) { $1 }
                .do(onNext: { (keystoreText: String) -> Void in
                    UIPasteboard.general.string = keystoreText
                    input.fromController.toastSubject.onNext(Toast("✅" + €.Event.Toast.didCopyKeystore))
                }).drive(),

            input.fromView.revealKeystoreTrigger
                .do(onNext: { userDid(.revealKeystore) })
                .drive(),

            input.fromView.revealPrivateKeyTrigger
                .do(onNext: { userDid(.revealPrivateKey) })
                .drive(),

            input.fromView.proceedTrigger.withLatestFrom(isUnderstandsRiskCheckboxChecked)
                .filter { $0 }.mapToVoid()
                .do(onNext: { userDid(.backupWallet) })
                .drive()
        ]

        return Output(
            isProceedButtonEnabled: isUnderstandsRiskCheckboxChecked
        )
    }
}

extension BackupWalletViewModel {

    struct InputFromView {
        let copyKeystoreToPasteboardTrigger: Driver<Void>
        let revealKeystoreTrigger: Driver<Void>
//        let copyPrivateKeyToPasteboardTrigger: Driver<Void>
        let revealPrivateKeyTrigger: Driver<Void>
        let isUnderstandsRiskCheckboxChecked: Driver<Bool>
        let proceedTrigger: Driver<Void>
    }

    struct Output {
        let isProceedButtonEnabled: Driver<Bool>
    }
}
