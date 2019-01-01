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
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let hasAnsweredAnalyticsPermissionsQuestionTrigger = Driver.merge(
            input.fromView.acceptTrigger.map { true },
            input.fromView.declineTrigger.map { false }
        )
        
        bag <~ [
            hasAnsweredAnalyticsPermissionsQuestionTrigger.do(onNext: { [unowned self] in
                self.useCase.answeredAnalyticsPermissionsQuestion(acceptsTracking: $0)
                self.navigator.next(.answerQuestionAboutAnalyticsPermission)
            }).drive()
        ]
        
        return Output(
            areButtonsEnabled: input.fromView.isHaveReadDisclaimerCheckboxChecked
        )
    }
}

extension AskForAnalyticsPermissionsViewModel {
    struct InputFromView {
        let isHaveReadDisclaimerCheckboxChecked: Driver<Bool>
        let acceptTrigger: Driver<Void>
        let declineTrigger: Driver<Void>
    }

    struct Output {
        let areButtonsEnabled: Driver<Bool>
    }
}
