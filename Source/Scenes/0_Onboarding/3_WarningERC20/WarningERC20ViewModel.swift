//
//  WarningERC20ViewModel.swift
//  Zhip
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
    private let allowedToSupress: Bool

    init(useCase: OnboardingUseCase, allowedToSupress: Bool = true) {
        self.useCase = useCase
        self.allowedToSupress = allowedToSupress
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

        return Output(
            isAcceptButtonEnabled: input.fromView.isUnderstandsERC20IncompatibilityCheckboxChecked,
            isDoNotShowAgainButtonVisible: Driver.just(allowedToSupress)
        )
    }
}

extension WarningERC20ViewModel {
    struct InputFromView {
        let isUnderstandsERC20IncompatibilityCheckboxChecked: Driver<Bool>
        let accept: Driver<Void>
        let doNotShowAgain: Driver<Void>
    }

    struct Output {
        let isAcceptButtonEnabled: Driver<Bool>
        let isDoNotShowAgainButtonVisible: Driver<Bool>
    }
}
