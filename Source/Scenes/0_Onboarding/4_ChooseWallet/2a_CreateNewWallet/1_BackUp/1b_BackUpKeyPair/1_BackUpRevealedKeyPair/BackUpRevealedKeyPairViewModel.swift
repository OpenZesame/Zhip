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

enum BackUpRevealedKeyPairUserAction: String, TrackedUserAction {
    case finish
}

private typealias € = L10n.Scene.BackUpRevealedKeyPair

final class BackUpRevealedKeyPairViewModel: BaseViewModel<
    BackUpRevealedKeyPairUserAction,
    BackUpRevealedKeyPairViewModel.InputFromView,
    BackUpRevealedKeyPairViewModel.Output
> {

    private let keyPair: KeyPair

    init(keyPair: KeyPair) {
        self.keyPair = keyPair
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ step: NavigationStep) {
            navigator.next(step)
        }

        let keyPair = Driver.just(self.keyPair)

        let privateKey = keyPair.map { $0.privateKey.asHexStringLength64() }
        let publicKeyUncompressed = keyPair.map { $0.publicKey.hex.uncompressed }

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.finish) })
                .drive(),

            input.fromView.copyPrivateKeyTrigger.withLatestFrom(privateKey) { $1 }
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext(Toast(€.Event.Toast.didCopyPrivateKey))
                }).drive(),

            input.fromView.copyPublicKeyTrigger.withLatestFrom(publicKeyUncompressed) { $1 }
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext(Toast(€.Event.Toast.didCopyPublicKey))
                }).drive()
        ]

        return Output(
            privateKey: privateKey,
            publicKeyUncompressed: publicKeyUncompressed
        )
    }
}

extension BackUpRevealedKeyPairViewModel {

    struct InputFromView {
        let copyPrivateKeyTrigger: Driver<Void>
        let copyPublicKeyTrigger: Driver<Void>
    }

    struct Output {
        let privateKey: Driver<String>
        let publicKeyUncompressed: Driver<String>
    }
}

