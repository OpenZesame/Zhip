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
private let encryptionPasswordMode: WalletEncryptionPassword.Mode = .restoreKeystore

// MARK: - RestoreWalletViewModel
final class RestoreWalletUsingKeystoreViewModel {

    let output: Output

    // swiftlint:disable:next function_body_length
    init(inputFromView: InputFromView) {

        // MARK: - Validate input
        let validator = InputValidator()

        let encryptionPasswordValidationValue = inputFromView.encryptionPassword.map { validator.validateEncryptionPassword($0) }

        let keyStoreValidationValue = inputFromView.keystoreText.map { validator.validateKeystore($0) }

        let encryptionPassword = encryptionPasswordValidationValue.map { $0.value?.validPassword }

        let encryptionPasswordValidation = Driver.merge(
            // map `editingChanged` to `editingDidBegin`
            inputFromView.encryptionPassword.mapToVoid().map { true },
            inputFromView.isEditingEncryptionPassword
            ).withLatestFrom(encryptionPasswordValidationValue) {
                EditingValidation(isEditing: $0, validation: $1.validation)
            }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(
            keyStoreValidationValue.map { $0.value },
            encryptionPassword
            ).map {
                guard let keystore = $0, let password = $1 else {
                    return nil
                }
                return KeyRestoration.keystore(keystore, password: password)
        }

        let encryptionPasswordPlaceHolder = Driver.just(€.Field.EncryptionPassword.keystore(WalletEncryptionPassword.minimumLenght(mode: encryptionPasswordMode)))

        let keystoreValidation = inputFromView.isEditingKeystore.withLatestFrom(keyStoreValidationValue) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keystoreTextFieldPlaceholder = inputFromView.keystoreDidBeginEditing
            .map { "" }
            .distinctUntilChanged() // never changed, thus only emitted once, as wished
            .startWith("Paste your keystore here")

        self.output = Output(
            keystoreTextFieldPlaceholder: keystoreTextFieldPlaceholder,
            encryptionPasswordPlaceholder: encryptionPasswordPlaceHolder,
            keyRestorationValidation: keystoreValidation,
            encryptionPasswordValidation: encryptionPasswordValidation,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingKeystoreViewModel {

    struct InputFromView {
        let keystoreDidBeginEditing: Driver<Void>
        let isEditingKeystore: Driver<Bool>
        let keystoreText: Driver<String>
        let encryptionPassword: Driver<String>
        let isEditingEncryptionPassword: Driver<Bool>
    }

    struct Output {
        let keystoreTextFieldPlaceholder: Driver<String>
        let encryptionPasswordPlaceholder: Driver<String>
        let keyRestorationValidation: Driver<AnyValidation>
        let encryptionPasswordValidation: Driver<AnyValidation>
        let keyRestoration: Driver<KeyRestoration?>
    }

    struct InputValidator {

        private let encryptionPasswordValidator = EncryptionPasswordValidator(mode: encryptionPasswordMode)

        private let keystoreValidator = KeystoreValidator()

        func validateKeystore(_ keystore: String) -> KeystoreValidator.Result {
            return keystoreValidator.validate(input: keystore)
        }

        func validateEncryptionPassword(_ password: String) -> EncryptionPasswordValidator.Result {
            return encryptionPasswordValidator.validate(input: (password: password, confirmingPassword: password))
        }
    }
}
