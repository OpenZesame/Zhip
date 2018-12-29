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
final class RestoreWalletUsingKeystoreViewModel {

    let output: Output

    init(inputFromView: InputFromView) {
        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .restore

        let validEncryptionPassphrase: Driver<String?> =
            inputFromView.encryptionPassphrase.map {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $0, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }
            .distinctUntilChanged()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(inputFromView.keystoreText, validEncryptionPassphrase) {
            guard let newEncryptionPassphrase = $1 else { return nil }
            return try? KeyRestoration(keyStoreJSONString: $0, encryptedBy: newEncryptionPassphrase)
        }

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.EncryptionPassphrase.keystore(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        let keystoreTextFieldPlaceholder = inputFromView.keystoreDidBeginEditing
            .map { "" }
            .distinctUntilChanged() // never changed, thus only emitted once, as wished
            .startWith("Paste your keystore here")

        self.output = Output(
            keystoreTextFieldPlaceholder: keystoreTextFieldPlaceholder,
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingKeystoreViewModel {

    struct InputFromView {
        let keystoreDidBeginEditing: Driver<Void>
        let keystoreText: Driver<String>
        let encryptionPassphrase: Driver<String>
    }

    struct Output {
        let keystoreTextFieldPlaceholder: Driver<String>
        let encryptionPassphrasePlaceholder: Driver<String>
        let keyRestoration: Driver<KeyRestoration?>
    }
}
