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
final class RestoreWalletUsingPrivateKeyViewModel {

    let output: Output

    // swiftlint:disable:next function_body_length
    init(inputFromView: InputFromView) {
        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .new

        let validEncryptionPassphrase: Driver<String?> = Observable.combineLatest(
            inputFromView.encryptionPassphrase.asObservable(),
            inputFromView.confirmEncryptionPassphrase.asObservable()
        ) {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $1, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }
            .asDriverOnErrorReturnEmpty()
            .distinctUntilChanged()

        let validPrivateKey: Driver<String?> = inputFromView.privateKey.map {
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

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.EncryptionPassphrase.privateKey(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        let privateKeyFieldIsSecureTextEntry = inputFromView.showPrivateKeyTrigger.scan(true) { lastState, newState in
            return !lastState
        }

        let togglePrivateKeyVisibilityButtonTitle = privateKeyFieldIsSecureTextEntry.map {
            $0 ? L10n.Generic.show : L10n.Generic.hide
        }

        self.output = Output(
            togglePrivateKeyVisibilityButtonTitle: togglePrivateKeyVisibilityButtonTitle,
            privateKeyFieldIsSecureTextEntry: privateKeyFieldIsSecureTextEntry,
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingPrivateKeyViewModel {

    struct InputFromView {
        let privateKey: Driver<String>
        let showPrivateKeyTrigger: Driver<Void>
        let encryptionPassphrase: Driver<String>
        let confirmEncryptionPassphrase: Driver<String>
    }

    struct Output {
        let togglePrivateKeyVisibilityButtonTitle: Driver<String>
        let privateKeyFieldIsSecureTextEntry: Driver<Bool>
        let encryptionPassphrasePlaceholder: Driver<String>
        let keyRestoration: Driver<KeyRestoration?>
    }
}
