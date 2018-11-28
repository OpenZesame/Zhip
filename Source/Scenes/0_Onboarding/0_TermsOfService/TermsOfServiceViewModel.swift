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

// MARK: TermsOfServiceNavigation
enum TermsOfServiceNavigation: TrackedUserAction {
    case acceptTermsOfService
}

// MARK: - TermsOfServiceViewModel
final class TermsOfServiceViewModel: BaseViewModel<
    TermsOfServiceNavigation,
    TermsOfServiceViewModel.InputFromView,
    TermsOfServiceViewModel.Output
> {

    private let useCase: OnboardingUseCase

    init(useCase: OnboardingUseCase) {
        self.useCase = useCase
    }
    
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let isAcceptButtonEnabled = input.fromView.didScrollToBottom.map { true }

        bag <~ [
            input.fromView.didAcceptTerms.do(onNext: { [unowned self] in
                self.useCase.didAcceptTermsOfService()
                userDid(.acceptTermsOfService)
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
