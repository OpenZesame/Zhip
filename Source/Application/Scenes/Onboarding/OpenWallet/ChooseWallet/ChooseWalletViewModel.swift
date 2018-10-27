//
//  ChooseWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChooseWalletViewModel: Navigatable {
    enum Step {
        case toCreate
        case toRestore
    }

    private let bag = DisposeBag()

    let stepper = Stepper<Step>()
}

extension ChooseWalletViewModel: ViewModelType {

    struct Input: InputType {
        struct FromView {
            let createNewTrigger: Driver<Void>
            let restoreTrigger: Driver<Void>
        }
        let fromView: FromView
        let fromController: ControllerInput

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {}

    func transform(input: Input) -> Output {
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
