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
private let encryptionPassphraseMode = WalletEncryptionPassphrase.Mode.newOrRestorePrivateKey

// MARK: - RestoreWalletUsingPrivateKeyViewModel
final class RestoreWalletUsingPrivateKeyViewModel {

    let output: Output

    // swiftlint:disable:next function_body_length
    init(inputFromView: InputFromView) {

        let validator = InputValidator()
        
        let privateKeyValidationValue = inputFromView.privateKey.map { validator.validatePrivateKey($0) }

        let unconfirmedPassphrase = inputFromView.newEncryptionPassphrase
        let confirmingPassphrase = inputFromView.confirmEncryptionPassphrase

        let confirmEncryptionPassphraseValidationValue = Driver.combineLatest(unconfirmedPassphrase, confirmingPassphrase)
            .map {
                validator.validateConfirmedEncryptionPassphrase($0.0, confirmedBy: $0.1)
        }

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.EncryptionPassphrase.privateKey(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        let privateKeyFieldIsSecureTextEntry = inputFromView.showPrivateKeyTrigger.scan(true) { lastState, newState in
            return !lastState
        }

        let togglePrivateKeyVisibilityButtonTitle = privateKeyFieldIsSecureTextEntry.map {
            $0 ? L10n.Generic.show : L10n.Generic.hide
        }

        let encryptionPassphraseValidationTrigger = Driver.merge(
            unconfirmedPassphrase.mapToVoid().map { true },
            inputFromView.isEditingNewEncryptionPassphrase
            )

        let encryptionPassphraseValidation: Driver<Validation> = encryptionPassphraseValidationTrigger.withLatestFrom(
            unconfirmedPassphrase.map { validator.validateNewEncryptionPassphrase($0) }
        ) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let confirmEncryptionPassphraseValidation: Driver<Validation> = Driver.combineLatest(
            Driver.merge(
                // map `editingChanged` to `editingDidBegin`
                confirmingPassphrase.mapToVoid().map { true },
                inputFromView.isEditingConfirmedEncryptionPassphrase
            ),
            encryptionPassphraseValidationTrigger // used for triggering, but value never used
        ).withLatestFrom(confirmEncryptionPassphraseValidationValue) {
            EditingValidation(isEditing: $0.0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(
            privateKeyValidationValue.map { $0.value },
            confirmEncryptionPassphraseValidationValue.map { $0.value }
        ).map {
            guard let privateKey = $0.0, let newEncryptionPassphrase = $0.1?.validPassphrase else {
                return nil
            }
            return KeyRestoration.privateKey(privateKey, encryptBy: newEncryptionPassphrase)
        }

        let privateKeyValidation = inputFromView.isEditingPrivateKey.withLatestFrom(privateKeyValidationValue) {
              EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        self.output = Output(
            togglePrivateKeyVisibilityButtonTitle: togglePrivateKeyVisibilityButtonTitle,
            privateKeyFieldIsSecureTextEntry: privateKeyFieldIsSecureTextEntry,
            privateKeyValidation: privateKeyValidation,
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            encryptionPassphraseValidation: encryptionPassphraseValidation,
            confirmEncryptionPassphraseValidation: confirmEncryptionPassphraseValidation,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingPrivateKeyViewModel {

    struct InputFromView {
        let privateKey: Driver<String>
        let isEditingPrivateKey: Driver<Bool>
        let showPrivateKeyTrigger: Driver<Void>
        let newEncryptionPassphrase: Driver<String>
        let isEditingNewEncryptionPassphrase: Driver<Bool>
        let confirmEncryptionPassphrase: Driver<String>
        let isEditingConfirmedEncryptionPassphrase: Driver<Bool>
    }

    struct Output {
        let togglePrivateKeyVisibilityButtonTitle: Driver<String>
        let privateKeyFieldIsSecureTextEntry: Driver<Bool>
        let privateKeyValidation: Driver<Validation>
        let encryptionPassphrasePlaceholder: Driver<String>
        let encryptionPassphraseValidation: Driver<Validation>
        let confirmEncryptionPassphraseValidation: Driver<Validation>
        let keyRestoration: Driver<KeyRestoration?>
    }

    struct InputValidator {
        private let privateKeyValidator = PrivateKeyValidator()

        func validatePrivateKey(_ privateKey: String?) -> PrivateKeyValidator.Result {
            return privateKeyValidator.validate(input: privateKey)
        }

        func validateNewEncryptionPassphrase(_ passphrase: String) -> EncryptionPassphraseValidator.Result {
            let validator = EncryptionPassphraseValidator(mode: encryptionPassphraseMode)
            return validator.validate(input: (passphrase, passphrase))
        }

        func validateConfirmedEncryptionPassphrase(_ passphrase: String, confirmedBy confirming: String) -> EncryptionPassphraseValidator.Result {
            let validator = EncryptionPassphraseValidator(mode: encryptionPassphraseMode)
            return validator.validate(input: (passphrase, confirming))
        }
    }
}
