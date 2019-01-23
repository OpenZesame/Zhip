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

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet
private let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .restoreKeystore

// MARK: - RestoreWalletViewModel
final class RestoreWalletUsingKeystoreViewModel {

    let output: Output

    // swiftlint:disable:next function_body_length
    init(inputFromView: InputFromView) {

        // MARK: - Validate input
        let validator = InputValidator()

        let encryptionPassphraseValidationValue = inputFromView.encryptionPassphrase.map { validator.validateEncryptionPassphrase($0) }

        let keyStoreValidationValue = inputFromView.keystoreText.map { validator.validateKeystore($0) }

        let encryptionPassphrase = encryptionPassphraseValidationValue.map { $0.value?.validPassphrase }

        let encryptionPassphraseValidation = Driver.merge(
            // map `editingChanged` to `editingDidBegin`
            inputFromView.encryptionPassphrase.mapToVoid().map { true },
            inputFromView.isEditingEncryptionPassphrase
            ).withLatestFrom(encryptionPassphraseValidationValue) {
                EditingValidation(isEditing: $0, validation: $1.validation)
            }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(
            keyStoreValidationValue.map { $0.value },
            encryptionPassphrase
            ).map {
                guard let keystore = $0, let passphrase = $1 else {
                    return nil
                }
                return KeyRestoration.keystore(keystore, passphrase: passphrase)
        }

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.EncryptionPassphrase.keystore(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        let keystoreValidation = inputFromView.isEditingKeystore.withLatestFrom(keyStoreValidationValue) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keystoreTextFieldPlaceholder = inputFromView.keystoreDidBeginEditing
            .map { "" }
            .distinctUntilChanged() // never changed, thus only emitted once, as wished
            .startWith("Paste your keystore here")

        self.output = Output(
            keystoreTextFieldPlaceholder: keystoreTextFieldPlaceholder,
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            keyRestorationValidation: keystoreValidation,
            encryptionPassphraseValidation: encryptionPassphraseValidation,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingKeystoreViewModel {

    struct InputFromView {
        let keystoreDidBeginEditing: Driver<Void>
        let isEditingKeystore: Driver<Bool>
        let keystoreText: Driver<String>
        let encryptionPassphrase: Driver<String>
        let isEditingEncryptionPassphrase: Driver<Bool>
    }

    struct Output {
        let keystoreTextFieldPlaceholder: Driver<String>
        let encryptionPassphrasePlaceholder: Driver<String>
        let keyRestorationValidation: Driver<AnyValidation>
        let encryptionPassphraseValidation: Driver<AnyValidation>
        let keyRestoration: Driver<KeyRestoration?>
    }

    struct InputValidator {

        private let encryptionPassphraseValidator = EncryptionPassphraseValidator(mode: encryptionPassphraseMode)

        private let keystoreValidator = KeystoreValidator()

        func validateKeystore(_ keystore: String) -> KeystoreValidator.Result {
            return keystoreValidator.validate(input: keystore)
        }

        func validateEncryptionPassphrase(_ passphrase: String) -> EncryptionPassphraseValidator.Result {
            return encryptionPassphraseValidator.validate(input: (passphrase: passphrase, confirmingPassphrase: passphrase))
        }
    }
}
