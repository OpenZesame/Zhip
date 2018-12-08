//
//  RestoreWalletUsingPrivateKeyViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWalletUsingPrivateKeyViewModel
final class RestoreWalletUsingPrivateKeyViewModel: SubViewModel<
    RestoreWalletUsingPrivateKeyViewModel.InputFromView,
    RestoreWalletUsingPrivateKeyViewModel.Output
> {
    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        let fromView = input.fromView

        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .new

        let validEncryptionPassphrase: Driver<String?> = Observable.combineLatest(
            fromView.encryptionPassphrase.asObservable(),
            fromView.confirmEncryptionPassphrase.asObservable()
        ) {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $1, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }
            .asDriverOnErrorReturnEmpty()
            .distinctUntilChanged()

        let validPrivateKey: Driver<String?> = fromView.privateKey.map {
            guard
                case let key = $0,
                key.count <= 64
                else { return nil }
            return key
        }

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(validPrivateKey, validEncryptionPassphrase) {
            guard let privateKeyHex = $0, let newEncryptionPassphrase = $1 else { return nil }
            return try? KeyRestoration(privateKeyHexString: privateKeyHex, encryptBy: newEncryptionPassphrase)
        }

        let isRestoreButtonEnabled = Driver.combineLatest(
            keyRestoration.map { $0 != nil },
            validEncryptionPassphrase.map { $0 != nil }
        ) { $0 && $1}

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        return Output(
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            isRestoreButtonEnabled: isRestoreButtonEnabled,
            keyRestoration: fromView.restoreTrigger.withLatestFrom(keyRestoration.filterNil()) { $1 }
        )
    }
}

extension RestoreWalletUsingPrivateKeyViewModel {

    struct InputFromView {
        let privateKey: Driver<String>

        let encryptionPassphrase: Driver<String>
        let confirmEncryptionPassphrase: Driver<String>

        let restoreTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let isRestoreButtonEnabled: Driver<Bool>
        let keyRestoration: Driver<KeyRestoration>
    }
}
