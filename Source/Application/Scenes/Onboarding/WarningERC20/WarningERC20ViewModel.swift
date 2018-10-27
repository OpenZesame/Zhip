//
//  WarningERC20ViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WarningERC20ViewModel: Navigatable {
    enum Step {
        case understandsRisks
        case understandsRisksSkipWarningFromNowOn
    }

    private let bag = DisposeBag()
    let stepper = Stepper<Step>()
}

extension WarningERC20ViewModel: ViewModelType {
    struct Input: InputType {
        struct FromView {
            let accept: Driver<Void>
            let doNotShowAgain: Driver<Void>
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
            fromView.accept.do(onNext: { [weak s=stepper] in
                s?.step(.understandsRisks)
            }).drive(),

            fromView.doNotShowAgain.do(onNext: { [weak s=stepper] in
                s?.step(.understandsRisksSkipWarningFromNowOn)
            }).drive()
        ]

        return Output()
    }
}
