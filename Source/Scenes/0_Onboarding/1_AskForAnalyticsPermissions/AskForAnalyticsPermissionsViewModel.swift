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
    case userOptedForAnalyticsPermissions
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

        let readDisclaimerTrigger = input.fromView.readDisclaimerTrigger

        bag <~ [
            input.fromView.acceptTrigger.do(onNext: { [unowned self] in
                self.useCase.optedForAnalyticsPermissions(acceptsTracking: true)
                userDid(.userOptedForAnalyticsPermissions)
            }).drive(),

            input.fromView.declineTrigger.do(onNext: { [unowned self] in
                self.useCase.optedForAnalyticsPermissions(acceptsTracking: false)
                userDid(.userOptedForAnalyticsPermissions)
            }).drive()
        ]
        return Output(
            areButtonsEnabled: readDisclaimerTrigger
        )
    }
}

extension AskForAnalyticsPermissionsViewModel {
    struct InputFromView {
        let readDisclaimerTrigger: Driver<Bool>
        let acceptTrigger: Driver<Void>
        let declineTrigger: Driver<Void>
    }

    struct Output {
        let areButtonsEnabled: Driver<Bool>
    }
}
