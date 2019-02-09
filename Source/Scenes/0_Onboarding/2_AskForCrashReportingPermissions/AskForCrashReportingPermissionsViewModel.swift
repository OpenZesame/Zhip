// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - AnalyticsPermissionNavigation
enum AskForCrashReportingPermissionsNavigation {
    case answerQuestionAboutCrashReporting
}

// MARK: - AnalyticsPermissionViewModel
final class AskForCrashReportingPermissionsViewModel: BaseViewModel<
    AskForCrashReportingPermissionsNavigation,
    AskForCrashReportingPermissionsViewModel.InputFromView,
    AskForCrashReportingPermissionsViewModel.Output
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
                self.useCase.answeredCrashReportingQuestion(acceptsCrashReporting: $0)
                self.navigator.next(.answerQuestionAboutCrashReporting)
            }).drive()
        ]
        
        return Output(
            areButtonsEnabled: input.fromView.isHaveReadDisclaimerCheckboxChecked
        )
    }
}

extension AskForCrashReportingPermissionsViewModel {
    struct InputFromView {
        let isHaveReadDisclaimerCheckboxChecked: Driver<Bool>
        let acceptTrigger: Driver<Void>
        let declineTrigger: Driver<Void>
    }

    struct Output {
        let areButtonsEnabled: Driver<Bool>
    }
}
