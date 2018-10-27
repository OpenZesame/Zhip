//
//  BackWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Zesame

final class BackupWalletViewModel: Navigatable {
    enum Step {
        case didBackup(wallet: Wallet)
    }

    let stepper = Stepper<Step>()
    private let bag = DisposeBag()
    private let wallet: Driver<Wallet>

    init(wallet: Wallet) {
        self.wallet = .just(wallet)
    }
}


extension BackupWalletViewModel: ViewModelType {

    func transform(input: Input) -> Output {

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
                .do(onNext: { [weak s=stepper] in s?.step(.didBackup(wallet: $0)) })
                .drive()
        ]

        return Output(
            keystoreText: keystoreText,
            isDoneButtonEnabled: understandsRisks
        )
    }

    struct Input: InputType {
        struct FromView {
            let copyKeystoreToPasteboardTrigger: Driver<Void>
            let understandsRisk: Driver<Bool>
            let doneTrigger: Driver<Void>
        }
        let fromView: FromView
        let fromController: ControllerInput
        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {
        let keystoreText: Driver<String?>
        let isDoneButtonEnabled: Driver<Bool>
    }
}
