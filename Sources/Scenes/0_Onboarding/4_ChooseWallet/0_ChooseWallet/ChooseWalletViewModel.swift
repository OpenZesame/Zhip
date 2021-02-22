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

import RxSwift
import RxCocoa

// MARK: - ChooseWalletUserAction
enum ChooseWalletUserAction {
    case createNewWallet
    case restoreWallet
}

// MARK: - ChooseWalletViewModel
final class ChooseWalletViewModel: BaseViewModel<
    ChooseWalletUserAction,
    ChooseWalletViewModel.InputFromView,
    ChooseWalletViewModel.Output
> {

    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        bag <~ [
            input.fromView.createNewWalletTrigger
                .do(onNext: { userIntends(to: .createNewWallet) })
                .drive(),

            input.fromView.restoreWalletTrigger
                .do(onNext: { userIntends(to: .restoreWallet) })
                .drive()
        ]
        return Output()
    }
}

extension ChooseWalletViewModel {

    struct InputFromView {
        let createNewWalletTrigger: Driver<Void>
        let restoreWalletTrigger: Driver<Void>
    }

    struct Output {}
}
