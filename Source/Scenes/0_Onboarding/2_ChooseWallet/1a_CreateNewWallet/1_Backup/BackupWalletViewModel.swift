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
    case backupWallet(Wallet)
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

        let keystoreText = wallet.map {
            try? JSONEncoder(outputFormatting: .prettyPrinted).encode($0.keystore)
        }.filterNil().map {
            String(data: $0, encoding: .utf8)
        }

        bag <~ [
            input.fromView.copyKeystoreToPasteboardTrigger.withLatestFrom(keystoreText)
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext(Toast("✅" + €.Event.Toast.didCopyKeystore))
                }).drive(),

            input.fromView.proceedTrigger.withLatestFrom(input.fromView.understandsRisk)
                .filter { $0 }
                .withLatestFrom(wallet)
                .do(onNext: { [unowned stepper] in stepper.step(.backupWallet($0)) })
                .drive()
        ]

        return Output(
            keystoreText: keystoreText,
            isProceedButtonEnabled: input.fromView.understandsRisk
        )
    }
}

extension BackupWalletViewModel {

    struct InputFromView {
        let copyKeystoreToPasteboardTrigger: Driver<Void>
        let understandsRisk: Driver<Bool>
        let proceedTrigger: Driver<Void>
    }

    struct Output {
        let keystoreText: Driver<String?>
        let isProceedButtonEnabled: Driver<Bool>
    }
}
