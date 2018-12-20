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

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        self.output = Output(
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingPrivateKeyViewModel {

    struct InputFromView {
        let privateKey: Driver<String>
        let encryptionPassphrase: Driver<String>
        let confirmEncryptionPassphrase: Driver<String>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let keyRestoration: Driver<KeyRestoration?>
    }
}
