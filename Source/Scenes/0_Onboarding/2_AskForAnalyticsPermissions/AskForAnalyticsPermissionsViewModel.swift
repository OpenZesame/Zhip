//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - AnalyticsPermissionNavigation
enum AskForAnalyticsPermissionsNavigation: String, TrackedUserAction {
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
