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

// MARK: - WarningERC20UserAction
enum WarningERC20UserAction: TrackedUserAction {
    case understandRisks
}

// MARK: - WarningERC20ViewModel
final class WarningERC20ViewModel: BaseViewModel<
    WarningERC20UserAction,
    WarningERC20ViewModel.InputFromView,
    WarningERC20ViewModel.Output
> {

    private let useCase: OnboardingUseCase

    init(useCase: OnboardingUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        func userDo(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let understandsRisks = Driver.merge(input.fromView.accept, input.fromView.doNotShowAgain)

        bag <~ [
            understandsRisks.do(onNext: { userDo(.understandRisks) })
                .drive(),

            input.fromView.doNotShowAgain.do(onNext: { [unowned useCase] in
                useCase.doNotShowERC20WarningAgain()
            }).drive()
        ]

        return Output()
    }
}

extension WarningERC20ViewModel {
    struct InputFromView {
        let accept: Driver<Void>
        let doNotShowAgain: Driver<Void>
    }

    struct Output {}
}
