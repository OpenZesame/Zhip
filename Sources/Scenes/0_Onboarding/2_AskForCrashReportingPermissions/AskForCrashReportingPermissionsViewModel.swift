//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Foundation

// MARK: - AnalyticsPermissionNavigation

enum AskForCrashReportingPermissionsNavigation {
    case answerQuestionAboutCrashReporting, dismiss
}

// MARK: - AnalyticsPermissionViewModel

final class AskForCrashReportingPermissionsViewModel: BaseViewModel<
    AskForCrashReportingPermissionsNavigation,
    AskForCrashReportingPermissionsViewModel.InputFromView,
    AskForCrashReportingPermissionsViewModel.Output
> {
    private let useCase: OnboardingUseCase
    private let isDismissible: Bool

    init(useCase: OnboardingUseCase, isDismissible: Bool) {
        self.useCase = useCase
        self.isDismissible = isDismissible
    }

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let hasAnsweredAnalyticsPermissionsQuestionTrigger = input.fromView.acceptTrigger.map { true }.merge(with: input.fromView.declineTrigger.map { false }).eraseToAnyPublisher()

        if isDismissible {
            input.fromController.rightBarButtonContentSubject.onBarButton(.done)
            bag <~ input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.dismiss) })
                .drive()
        }

        bag <~ [
            hasAnsweredAnalyticsPermissionsQuestionTrigger.do(onNext: { [unowned self] in
                useCase.answeredCrashReportingQuestion(acceptsCrashReporting: $0)
                navigator.next(.answerQuestionAboutCrashReporting)
            }).drive(),
        ]

        return Output(
            areButtonsEnabled: input.fromView.isHaveReadDisclaimerCheckboxChecked
        )
    }
}

extension AskForCrashReportingPermissionsViewModel {
    struct InputFromView {
        let isHaveReadDisclaimerCheckboxChecked: AnyPublisher<Bool, Never>
        let acceptTrigger: AnyPublisher<Void, Never>
        let declineTrigger: AnyPublisher<Void, Never>
    }

    struct Output {
        let areButtonsEnabled: AnyPublisher<Bool, Never>
    }
}
