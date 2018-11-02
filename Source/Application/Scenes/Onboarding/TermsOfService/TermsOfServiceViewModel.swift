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

final class TermsOfServiceViewModel: AbstractViewModel<
    TermsOfServiceViewModel.Step,
    TermsOfServiceViewModel.InputFromView,
    TermsOfServiceViewModel.Output
> {
    enum Step: String, TrackedUserAction {
        case userAcceptedTerms
    }

    override func transform(input: Input) -> Output {

        let fromView = input.fromView

        let isAcceptButtonEnabled = fromView.didScrollToBottom.map { true }

        bag <~ [
            fromView.didAcceptTerms.do(onNext: { [unowned stepper] in
                stepper.step(.userAcceptedTerms)
            }).drive()
        ]

        return Output(
            isAcceptButtonEnabled: isAcceptButtonEnabled
        )
    }
}

extension TermsOfServiceViewModel {

    struct InputFromView {
        let didScrollToBottom: Driver<Void>
        let didAcceptTerms: Driver<Void>
    }

    struct Output {
        let isAcceptButtonEnabled: Driver<Bool>
    }
}
