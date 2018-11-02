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

final class BackupWalletViewModel: AbstractViewModel<
    BackupWalletViewModel.Step,
    BackupWalletViewModel.InputFromView,
    BackupWalletViewModel.Output
> {
    enum Step {
        case didBackup(wallet: Wallet)
    }

    private let wallet: Driver<Wallet>

    init(wallet: Wallet) {
        self.wallet = .just(wallet)
    }

    override func transform(input: Input) -> Output {
        let keystoreText = wallet.map {
            try? JSONEncoder(outputFormatting: .prettyPrinted).encode($0.keystore)
        }.filterNil().map {
            String(data: $0, encoding: .utf8)
        }

        let understandsRisks = input.fromView.understandsRisk

        bag <~ [
            input.fromView.copyKeystoreToPasteboardTrigger.withLatestFrom(keystoreText)
                .do(onNext: {
                    UIPasteboard.general.string = $0
                }).drive(),

            input.fromView.doneTrigger.withLatestFrom(understandsRisks)
                .filter { $0 }
                .withLatestFrom(wallet)
                .do(onNext: { [unowned stepper] in stepper.step(.didBackup(wallet: $0)) })
                .drive()
        ]

        return Output(
            keystoreText: keystoreText,
            isDoneButtonEnabled: understandsRisks
        )
    }
}

extension BackupWalletViewModel {

    struct InputFromView {
        let copyKeystoreToPasteboardTrigger: Driver<Void>
        let understandsRisk: Driver<Bool>
        let doneTrigger: Driver<Void>
    }

    struct Output {
        let keystoreText: Driver<String?>
        let isDoneButtonEnabled: Driver<Bool>
    }
}
