//
//  TermsOfServiceViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TermsOfServiceViewModel: Navigatable {
    enum Step {
        case didAcceptTerms
    }

    private let bag = DisposeBag()
    let stepper = Stepper<Step>()
}

extension TermsOfServiceViewModel: ViewModelType {

    struct Input: InputType {
        struct FromView {
            let didScrollToBottom: Driver<Void>
            let didAcceptTerms: Driver<Void>
        }
        let fromView: FromView
        let fromController: ControllerInput

        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {
        let isAcceptButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let fromView = input.fromView

        let isAcceptButtonEnabled = fromView.didScrollToBottom.map { true }

        bag <~ [
            fromView.didAcceptTerms.do(onNext: { [weak s=stepper] in
                s?.step(.didAcceptTerms)
            }).drive()
        ]

        return Output(
            isAcceptButtonEnabled: isAcceptButtonEnabled
        )

    }
}
