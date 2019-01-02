//
//  BackUpKeystoreViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
