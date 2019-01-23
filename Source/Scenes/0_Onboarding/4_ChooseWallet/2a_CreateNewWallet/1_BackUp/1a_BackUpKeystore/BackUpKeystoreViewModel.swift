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

import Zesame

import RxSwift
import RxCocoa

private typealias € = L10n.Scene.BackUpKeystore

enum BackUpKeystoreUserAction: String, TrackedUserAction {
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
