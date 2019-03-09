// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
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

import Zesame

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet
private let encryptionPasswordMode = WalletEncryptionPassword.Mode.newOrRestorePrivateKey

// MARK: - RestoreWalletUsingPrivateKeyViewModel
final class RestoreWalletUsingPrivateKeyViewModel {

    let output: Output

    // swiftlint:disable:next function_body_length
    init(inputFromView: InputFromView) {

        let validator = InputValidator()
        
        let privateKeyValidationValue = inputFromView.privateKey.map { validator.validatePrivateKey($0) }

        let unconfirmedPassword = inputFromView.newEncryptionPassword
        let confirmingPassword = inputFromView.confirmEncryptionPassword

        let confirmEncryptionPasswordValidationValue = Driver.combineLatest(unconfirmedPassword, confirmingPassword)
            .map {
                validator.validateConfirmedEncryptionPassword($0.0, confirmedBy: $0.1)
        }

        let encryptionPasswordPlaceHolder = Driver.just(€.Field.EncryptionPassword.privateKey(WalletEncryptionPassword.minimumLenght(mode: encryptionPasswordMode)))

        let privateKeyFieldIsSecureTextEntry = inputFromView.showPrivateKeyTrigger.scan(true) { lastState, newState in
            return !lastState
        }

        let togglePrivateKeyVisibilityButtonTitle = privateKeyFieldIsSecureTextEntry.map {
            $0 ? L10n.Generic.show : L10n.Generic.hide
        }

        let encryptionPasswordValidationTrigger = Driver.merge(
            unconfirmedPassword.mapToVoid().map { true },
            inputFromView.isEditingNewEncryptionPassword
            )

        let encryptionPasswordValidation: Driver<AnyValidation> = encryptionPasswordValidationTrigger.withLatestFrom(
            unconfirmedPassword.map { validator.validateNewEncryptionPassword($0) }
        ) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let confirmEncryptionPasswordValidation: Driver<AnyValidation> = Driver.combineLatest(
            Driver.merge(
                // map `editingChanged` to `editingDidBegin`
                confirmingPassword.mapToVoid().map { true },
                inputFromView.isEditingConfirmedEncryptionPassword
            ),
            encryptionPasswordValidationTrigger // used for triggering, but value never used
        ).withLatestFrom(confirmEncryptionPasswordValidationValue) {
            EditingValidation(isEditing: $0.0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(
            privateKeyValidationValue.map { $0.value },
            confirmEncryptionPasswordValidationValue.map { $0.value }
        ).map {
            guard let privateKey = $0.0, let newEncryptionPassword = $0.1?.validPassword else {
                return nil
            }
            return KeyRestoration.privateKey(privateKey, encryptBy: newEncryptionPassword, kdf: .default)
        }

        let privateKeyValidation = inputFromView.isEditingPrivateKey.withLatestFrom(privateKeyValidationValue) {
              EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        self.output = Output(
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
        let privateKey: Driver<String>
        let isEditingPrivateKey: Driver<Bool>
        let showPrivateKeyTrigger: Driver<Void>
        let newEncryptionPassword: Driver<String>
        let isEditingNewEncryptionPassword: Driver<Bool>
        let confirmEncryptionPassword: Driver<String>
        let isEditingConfirmedEncryptionPassword: Driver<Bool>
    }

    struct Output {
        let togglePrivateKeyVisibilityButtonTitle: Driver<String>
        let privateKeyFieldIsSecureTextEntry: Driver<Bool>
        let privateKeyValidation: Driver<AnyValidation>
        let encryptionPasswordPlaceholder: Driver<String>
        let encryptionPasswordValidation: Driver<AnyValidation>
        let confirmEncryptionPasswordValidation: Driver<AnyValidation>
        let keyRestoration: Driver<KeyRestoration?>
    }

    struct InputValidator {
        private let privateKeyValidator = PrivateKeyValidator()

        func validatePrivateKey(_ privateKey: String?) -> PrivateKeyValidator.Result {
            return privateKeyValidator.validate(input: privateKey)
        }

        func validateNewEncryptionPassword(_ password: String) -> EncryptionPasswordValidator.Result {
            let validator = EncryptionPasswordValidator(mode: encryptionPasswordMode)
            return validator.validate(input: (password, password))
        }

        func validateConfirmedEncryptionPassword(_ password: String, confirmedBy confirming: String) -> EncryptionPasswordValidator.Result {
            let validator = EncryptionPasswordValidator(mode: encryptionPasswordMode)
            return validator.validate(input: (password, confirming))
        }
    }
}
