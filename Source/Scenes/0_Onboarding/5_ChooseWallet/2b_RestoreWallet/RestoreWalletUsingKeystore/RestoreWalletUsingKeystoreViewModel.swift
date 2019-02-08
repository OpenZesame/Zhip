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
