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

// MARK: - WarningERC20UserAction
enum WarningERC20UserAction: String, TrackedUserAction {
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
