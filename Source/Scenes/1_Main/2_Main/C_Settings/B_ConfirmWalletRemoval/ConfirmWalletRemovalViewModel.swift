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

// MARK: - User action and navigation steps
enum ConfirmWalletRemovalUserAction {
    case /*user did*/cancel, confirm
}

// MARK: - ConfirmWalletRemovalViewModel
private typealias € = L10n.Scene.ConfirmWalletRemoval

final class ConfirmWalletRemovalViewModel: BaseViewModel<
    ConfirmWalletRemovalUserAction,
    ConfirmWalletRemovalViewModel.InputFromView,
    ConfirmWalletRemovalViewModel.Output
> {
    private let useCase: WalletUseCase

    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        // MARK: Navigate
        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            input.fromView.confirmTrigger
                .do(onNext: { userDid(.confirm) })
                .drive()
        ]

        // MARK: Return output
        return Output(
            isConfirmButtonEnabled: input.fromView.isWalletBackedUpCheckboxChecked
        )
    }
}

extension ConfirmWalletRemovalViewModel {
    
    struct InputFromView {
        let confirmTrigger: Driver<Void>
        let isWalletBackedUpCheckboxChecked: Driver<Bool>
    }

    struct Output {
        let isConfirmButtonEnabled: Driver<Bool>
    }
}
