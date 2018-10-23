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

    struct Input {
        let didScrollToBottom: Driver<Void>
        let didAcceptTerms: Driver<Void>
    }

    struct Output {
        let isAcceptButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let isAcceptButtonEnabled = input.didScrollToBottom.map { true }

        input.didAcceptTerms.do(onNext: {
            self.useCase.didAcceptTermsOfService()
            self.actionListener?.didAcceptTerms()
        }).drive().disposed(by: bag)

        return Output(
            isAcceptButtonEnabled: isAcceptButtonEnabled
        )

    }
}
