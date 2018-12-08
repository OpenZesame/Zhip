//
//  RestoreWalletUsingKeystoreViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWalletViewModel
final class RestoreWalletUsingKeystoreViewModel: SubViewModel<
    RestoreWalletUsingKeystoreViewModel.InputFromView,
    RestoreWalletUsingKeystoreViewModel.Output
> {

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {

        let fromView = input.fromView

        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .restore

        let validEncryptionPassphrase: Driver<String?> =
            fromView.encryptionPassphrase.map {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $0, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }
            .distinctUntilChanged()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(fromView.keystoreText, validEncryptionPassphrase) {
            guard let newEncryptionPassphrase = $1 else { return nil }
            return try? KeyRestoration(keyStoreJSONString: $0, encryptedBy: newEncryptionPassphrase)
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

extension RestoreWalletUsingKeystoreViewModel {

    struct InputFromView {
        let keystoreText: Driver<String>

        let encryptionPassphrase: Driver<String>

        let restoreTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let isRestoreButtonEnabled: Driver<Bool>
        let keyRestoration: Driver<KeyRestoration>
    }
}
