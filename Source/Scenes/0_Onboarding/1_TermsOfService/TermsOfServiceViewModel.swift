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

// MARK: TermsOfServiceNavigation
enum TermsOfServiceNavigation: String, TrackedUserAction {
    case acceptTermsOfService, dismiss
}

// MARK: - TermsOfServiceViewModel
final class TermsOfServiceViewModel: BaseViewModel<
    TermsOfServiceNavigation,
    TermsOfServiceViewModel.InputFromView,
    TermsOfServiceViewModel.Output
> {

    private let useCase: OnboardingUseCase
    private let isDismissable: Bool

    init(useCase: OnboardingUseCase, isDismissable: Bool) {
        self.useCase = useCase
        self.isDismissable = isDismissable
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let isAcceptButtonEnabled = input.fromView.didScrollToBottom.map { true }

        if isDismissable {
            input.fromController.rightBarButtonContentSubject.onBarButton(.done)
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.dismiss) })
                .drive().disposed(by: bag)
        }

        bag <~ [
            input.fromView.didAcceptTerms.do(onNext: { [unowned self] in
                self.useCase.didAcceptTermsOfService()
                userDid(.acceptTermsOfService)
            }).drive()
        ]

        return Output(
            isAcceptButtonVisible: Driver.just(!isDismissable),
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
        let isAcceptButtonVisible: Driver<Bool>
        let isAcceptButtonEnabled: Driver<Bool>
    }
}
