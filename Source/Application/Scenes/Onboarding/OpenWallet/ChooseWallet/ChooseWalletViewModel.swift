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
        case toCreate
        case toRestore
    }

    override func transform(input: Input) -> Output {
        let fromView = input.fromView

        bag <~ [
            fromView.createNewTrigger.do(onNext: { [weak s=stepper] in
                s?.step(.toCreate)
            }).drive(),

            fromView.restoreTrigger.do(onNext: { [weak s=stepper] in
                s?.step(.toRestore)
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
