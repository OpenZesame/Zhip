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

protocol TermsOfServiceActionListener: AnyObject {
    func didAcceptTerms()
}

final class TermsOfServiceViewModel {

    private let bag = DisposeBag()

    private weak var actionListener: TermsOfServiceActionListener?
    private let useCase: OnboardingUseCase

    init(actionListener: TermsOfServiceActionListener, useCase: OnboardingUseCase) {
        self.actionListener = actionListener
        self.useCase = useCase
    }
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

        fromView.didAcceptTerms.do(onNext: {
            self.useCase.didAcceptTermsOfService()
            self.actionListener?.didAcceptTerms()
        }).drive().disposed(by: bag)

        return Output(
            isAcceptButtonEnabled: isAcceptButtonEnabled
        )

    }
}
