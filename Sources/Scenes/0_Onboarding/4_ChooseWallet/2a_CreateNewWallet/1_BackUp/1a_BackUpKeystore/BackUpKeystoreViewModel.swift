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

import Zesame

import RxSwift
import RxCocoa
import UIKit

private typealias € = L10n.Scene.BackUpKeystore

enum BackUpKeystoreUserAction {
    case finished
}

final class BackUpKeystoreViewModel: BaseViewModel<
    BackUpKeystoreUserAction,
    BackUpKeystoreViewModel.InputFromView,
    BackUpKeystoreViewModel.Output
> {

    private let keystore: Driver<Keystore>

    init(keystore: Driver<Keystore>) {
        self.keystore = keystore
    }

    override func transform(input: Input) -> Output {
        func userDid(_ step: NavigationStep) {
            navigator.next(step)
        }

        let keystore = self.keystore.map { $0.asPrettyPrintedJSONString }

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.finished) })
                .drive(),

            input.fromView.copyTrigger.withLatestFrom(keystore)
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    let toast = Toast(€.Event.Toast.didCopyKeystore)
                    input.fromController.toastSubject.onNext(toast)
                })
                .drive()
        ]

        return Output(
            keystore: keystore
        )
    }
}

extension BackUpKeystoreViewModel {
    convenience init(wallet: Driver<Wallet>) {
        self.init(keystore: wallet.map { $0.keystore })
    }
}

extension BackUpKeystoreViewModel {
    struct InputFromView {
        let copyTrigger: Driver<Void>
    }

    struct Output {
        let keystore: Driver<String>
    }
}
