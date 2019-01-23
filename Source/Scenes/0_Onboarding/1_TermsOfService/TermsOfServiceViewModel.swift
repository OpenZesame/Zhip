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

// MARK: TermsOfServiceNavigation
enum TermsOfServiceNavigation: String, TrackedUserAction {
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
