//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Combine
import Zesame

private let encryptionPasswordMode = WalletEncryptionPassword.Mode.newOrRestorePrivateKey

// MARK: - RestoreWalletUsingPrivateKeyViewModel

final class RestoreWalletUsingPrivateKeyViewModel {
    let output: Output

    init(inputFromView: InputFromView) {
        let validator = InputValidator()

        let privateKeyValidationValue = inputFromView.privateKey.map { validator.validatePrivateKey($0) }
            .eraseToAnyPublisher()

        let unconfirmedPassword = inputFromView.newEncryptionPassword
        let confirmingPassword = inputFromView.confirmEncryptionPassword

        let confirmEncryptionPasswordValidationValue: AnyPublisher<EncryptionPasswordValidator.ValidationResult, Never> =
            unconfirmedPassword.combineLatest(confirmingPassword).eraseToAnyPublisher()
            .map {
                validator.validateConfirmedEncryptionPassword($0.0, confirmedBy: $0.1)
            }.eraseToAnyPublisher()

        let encryptionPasswordPlaceHolder = Just(String(localized: .RestoreWallet
            .privateKeyEncryptionPasswordField(minLength: WalletEncryptionPassword
                .minimumLength(mode: encryptionPasswordMode))))
            .eraseToAnyPublisher()

        let privateKeyFieldIsSecureTextEntry: AnyPublisher<Bool, Never> = inputFromView.showPrivateKeyTrigger.scan(true) { lastState, _ in
            !lastState
        }.eraseToAnyPublisher()

        let togglePrivateKeyVisibilityButtonTitle: AnyPublisher<String, Never> = privateKeyFieldIsSecureTextEntry.map {
            $0 ? String(localized: .Generic.show) : String(localized: .Generic.hide)
        }.eraseToAnyPublisher()

        let encryptionPasswordValidationTrigger: AnyPublisher<Bool, Never> = unconfirmedPassword.mapToVoid().map { true }
            .merge(with: inputFromView.isEditingNewEncryptionPassword)
            .eraseToAnyPublisher()

        let encryptionPasswordValidation: AnyPublisher<AnyValidation, Never> = encryptionPasswordValidationTrigger.withLatestFrom(
            unconfirmedPassword.map { validator.validateNewEncryptionPassword($0) }.eraseToAnyPublisher()
        ) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        // map `editingChanged` to `editingDidBegin`
        let confirmEditingTrigger = confirmingPassword.mapToVoid().map { true }
            .merge(with: inputFromView.isEditingConfirmedEncryptionPassword)
            .eraseToAnyPublisher()

        // encryptionPasswordValidationTrigger used solely to trigger re-evaluation; value discarded
        let confirmEncryptionPasswordValidation: AnyPublisher<AnyValidation, Never> = confirmEditingTrigger
            .combineLatest(encryptionPasswordValidationTrigger)
            .withLatestFrom(confirmEncryptionPasswordValidationValue) {
                EditingValidation(isEditing: $0.0, validation: $1.validation)
            }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keyRestoration: AnyPublisher<KeyRestoration?, Never> = privateKeyValidationValue.map(\.value)
            .combineLatest(confirmEncryptionPasswordValidationValue.map(\.value))
            .map {
                guard let privateKey = $0.0, let newEncryptionPassword = $0.1?.validPassword else {
                    return nil
                }
                return KeyRestoration.privateKey(privateKey, encryptBy: newEncryptionPassword, kdf: .default)
            }.eraseToAnyPublisher()

        let privateKeyValidation: AnyPublisher<AnyValidation, Never> = inputFromView.isEditingPrivateKey
            .withLatestFrom(privateKeyValidationValue) {
                EditingValidation(isEditing: $0, validation: $1.validation)
            }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        output = Output(
            togglePrivateKeyVisibilityButtonTitle: togglePrivateKeyVisibilityButtonTitle,
            privateKeyFieldIsSecureTextEntry: privateKeyFieldIsSecureTextEntry,
            privateKeyValidation: privateKeyValidation,
            encryptionPasswordPlaceholder: encryptionPasswordPlaceHolder,
            encryptionPasswordValidation: encryptionPasswordValidation,
            confirmEncryptionPasswordValidation: confirmEncryptionPasswordValidation,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingPrivateKeyViewModel {
    struct InputFromView {
        let privateKey: AnyPublisher<String, Never>
        let isEditingPrivateKey: AnyPublisher<Bool, Never>
        let showPrivateKeyTrigger: AnyPublisher<Void, Never>
        let newEncryptionPassword: AnyPublisher<String, Never>
        let isEditingNewEncryptionPassword: AnyPublisher<Bool, Never>
        let confirmEncryptionPassword: AnyPublisher<String, Never>
        let isEditingConfirmedEncryptionPassword: AnyPublisher<Bool, Never>
    }

    struct Output {
        let togglePrivateKeyVisibilityButtonTitle: AnyPublisher<String, Never>
        let privateKeyFieldIsSecureTextEntry: AnyPublisher<Bool, Never>
        let privateKeyValidation: AnyPublisher<AnyValidation, Never>
        let encryptionPasswordPlaceholder: AnyPublisher<String, Never>
        let encryptionPasswordValidation: AnyPublisher<AnyValidation, Never>
        let confirmEncryptionPasswordValidation: AnyPublisher<AnyValidation, Never>
        let keyRestoration: AnyPublisher<KeyRestoration?, Never>
    }

    struct InputValidator {
        private let privateKeyValidator = PrivateKeyValidator()

        func validatePrivateKey(_ privateKey: String?) -> PrivateKeyValidator.ValidationResult {
            privateKeyValidator.validate(input: privateKey)
        }

        func validateNewEncryptionPassword(_ password: String) -> EncryptionPasswordValidator.ValidationResult {
            let validator = EncryptionPasswordValidator(mode: encryptionPasswordMode)
            return validator.validate(input: (password, password))
        }

        func validateConfirmedEncryptionPassword(
            _ password: String,
            confirmedBy confirming: String
        ) -> EncryptionPasswordValidator.ValidationResult {
            let validator = EncryptionPasswordValidator(mode: encryptionPasswordMode)
            return validator.validate(input: (password, confirming))
        }
    }
}
