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

// MARK: - WarningERC20UserAction
enum WarningERC20UserAction {
    case understandRisks, dismiss
}

// MARK: - WarningERC20ViewModel
final class WarningERC20ViewModel: BaseViewModel<
    WarningERC20UserAction,
    WarningERC20ViewModel.InputFromView,
    WarningERC20ViewModel.Output
> {
    enum Mode {
        case dismissible
        case userHaveToAccept(isDoNotShowAgainButtonVisible: Bool)
    }

    private let useCase: OnboardingUseCase
    private let mode: Mode

    init(
        useCase: OnboardingUseCase,
        mode: Mode
    ) {
        self.useCase = useCase
        self.mode = mode
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let understandsRisks = Driver.merge(input.fromView.accept, input.fromView.doNotShowAgain)

        if isDismissible {
            input.fromController.rightBarButtonContentSubject.onBarButton(.done)
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.dismiss) })
                .drive().disposed(by: bag)
        }

        bag <~ [
            understandsRisks.do(onNext: { userDid(.understandRisks) })
                .drive(),

            input.fromView.doNotShowAgain.do(onNext: { [unowned useCase] in
                useCase.doNotShowERC20WarningAgain()
            }).drive()
        ]

        return Output(
            isDoNotShowAgainButtonVisible: Driver.just(isDoNotShowAgainButtonVisible),
            isAcceptButtonCheckboxVisible: Driver.just(!isDismissible),
            isAcceptButtonEnabled: input.fromView.isUnderstandsERC20IncompatibilityCheckboxChecked
        )
    }
}

private extension WarningERC20ViewModel {
    var isDoNotShowAgainButtonVisible: Bool {
        switch mode {
        case .dismissible: return false
        case .userHaveToAccept(let isDoNotShowAgainButtonVisible): return isDoNotShowAgainButtonVisible
        }
    }

    var isDismissible: Bool {
        switch mode {
        case .dismissible: return true
        case .userHaveToAccept: return false
        }
    }
}

extension WarningERC20ViewModel {
    struct InputFromView {
        let isUnderstandsERC20IncompatibilityCheckboxChecked: Driver<Bool>
        let accept: Driver<Void>
        let doNotShowAgain: Driver<Void>
    }

    struct Output {
        let isDoNotShowAgainButtonVisible: Driver<Bool>
        let isAcceptButtonCheckboxVisible: Driver<Bool>
        let isAcceptButtonEnabled: Driver<Bool>
    }
}
