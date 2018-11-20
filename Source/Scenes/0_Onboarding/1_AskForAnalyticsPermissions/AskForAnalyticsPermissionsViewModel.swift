//
//  AskForAnalyticsPermissionsViewModel.swift
//  Zupreme
//
//  Created by Andrei Radulescu on 09/11/2018.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - AnalyticsPermissionNavigation
enum AskForAnalyticsPermissionsNavigation: TrackedUserAction {
    case answerQuestionAboutAnalyticsPermission
}

// MARK: - AnalyticsPermissionViewModel
final class AskForAnalyticsPermissionsViewModel: BaseViewModel<
    AskForAnalyticsPermissionsNavigation,
    AskForAnalyticsPermissionsViewModel.InputFromView,
    AskForAnalyticsPermissionsViewModel.Output
> {

    private let useCase: OnboardingUseCase

    init(useCase: OnboardingUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: Step) {
            stepper.step(userAction)
        }

        let haveReadDisclaimerTrigger = input.fromView.haveReadDisclaimerTrigger

        let hasAnsweredAnalyticsPermissionsQuestionTrigger = Driver.merge(
            input.fromView.acceptTrigger.map { true },
            input.fromView.declineTrigger.map { false }
        )
        
        bag <~ [
            hasAnsweredAnalyticsPermissionsQuestionTrigger.do(onNext: { [unowned self] in
                self.useCase.answeredAnalyticsPermissionsQuestion(acceptsTracking: $0)
                self.stepper.step(.answerQuestionAboutAnalyticsPermission)
            }).drive()
        ]
        
        return Output(
            areButtonsEnabled: haveReadDisclaimerTrigger
        )
    }
}

extension AskForAnalyticsPermissionsViewModel {
    struct InputFromView {
        let haveReadDisclaimerTrigger: Driver<Bool>
        let acceptTrigger: Driver<Void>
        let declineTrigger: Driver<Void>
    }

    struct Output {
        let areButtonsEnabled: Driver<Bool>
    }
}
