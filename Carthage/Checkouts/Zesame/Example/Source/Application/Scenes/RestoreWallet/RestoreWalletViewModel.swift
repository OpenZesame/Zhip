//
//  RestoreWalletViewModel.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxCocoa
import RxSwift
import Zesame

final class RestoreWalletViewModel {
    private let bag = DisposeBag()

    private weak var navigator: RestoreWalletNavigator?
    private let service: ZilliqaServiceReactive

    init(navigator: RestoreWalletNavigator, service: ZilliqaServiceReactive) {
        self.navigator = navigator
        self.service = service
    }
}

extension RestoreWalletViewModel: ViewModelType {

    struct Input {
        let privateKey: Driver<String?>
        let encryptionPassphrase: Driver<String?>
        let confirmEncryptionPassphrase: Driver<String?>
        let restoreTrigger: Driver<Void>
    }

    struct Output {
        let isRestoreButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let validEncryptionPassphrase: Driver<String?> = Driver.combineLatest(input.encryptionPassphrase, input.confirmEncryptionPassphrase) {
            guard
                $0 == $1,
                let newPassphrase = $0,
                newPassphrase.count >= 3
                else { return nil }
            return newPassphrase
        }

        let validPrivateKey: Driver<String?> = input.privateKey.map {
            guard
                let key = $0,
                key.count == 64
                else { return nil }
            return key
        }

        let isRestoreButtonEnabled = Driver.combineLatest(validEncryptionPassphrase, validPrivateKey) { ($0, $1) }.map { $0 != nil && $1 != nil }

        let wallet = Driver.combineLatest(validPrivateKey.filterNil(), validEncryptionPassphrase.filterNil()) {
            try? KeyRestoration(privateKeyHexString: $0, encryptBy: $1)
        }.filterNil()
        .flatMapLatest {
            self.service.restoreWallet(from: $0)
                .asDriverOnErrorReturnEmpty()
        }

        input.restoreTrigger
            .withLatestFrom(wallet).do(onNext: {
                self.navigator?.toMain(restoredWallet: $0)
            }).drive().disposed(by: bag)

        return Output(
            isRestoreButtonEnabled: isRestoreButtonEnabled
        )
    }
}
