//
//  BackUpRevealedKeyPairViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxSwift
import RxCocoa

enum BackUpRevealedKeyPairUserAction: TrackedUserAction {
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
                    input.fromController.toastSubject.onNext(Toast("✅" + €.Event.Toast.didCopyPrivateKey))
                }).drive(),

            input.fromView.copyPublicKeyTrigger.withLatestFrom(publicKeyUncompressed) { $1 }
                .do(onNext: {
                    UIPasteboard.general.string = $0
                    input.fromController.toastSubject.onNext(Toast("✅" + €.Event.Toast.didCopyPublicKey))
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

