//
//  ChooseWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChooseWalletViewModel: AbstractViewModel<
    ChooseWalletViewModel.Step,
    ChooseWalletViewModel.InputFromView,
    ChooseWalletViewModel.Output
> {
    enum Step {
        case userSelectedCreateNewWallet
        case userSelectedRestoreWallet
    }

    override func transform(input: Input) -> Output {
        let fromView = input.fromView

        bag <~ [
            fromView.createNewTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.userSelectedCreateNewWallet)
            }).drive(),

            fromView.restoreTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.userSelectedRestoreWallet)
            }).drive()
        ]
        return Output()
    }
}

extension ChooseWalletViewModel {

    struct InputFromView {
        let createNewTrigger: Driver<Void>
        let restoreTrigger: Driver<Void>
    }

    struct Output {}
}
