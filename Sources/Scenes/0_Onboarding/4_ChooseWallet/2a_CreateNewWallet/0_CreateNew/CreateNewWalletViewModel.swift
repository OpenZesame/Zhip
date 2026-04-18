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
import Factory
import Foundation
import Zesame

private let encryptionPasswordMode: WalletEncryptionPassword.Mode = .newOrRestorePrivateKey

// MARK: - CreateNewWalletUserAction

enum CreateNewWalletUserAction {
    case createWallet(Wallet), cancel
}

// MARK: - CreateNewWalletViewModel

final class CreateNewWalletViewModel:
    BaseViewModel<
        CreateNewWalletUserAction,
        CreateNewWalletViewModel.InputFromView,
        CreateNewWalletViewModel.Output
    >
// swiftlint:disable:next opening_brace
{
    @Injected(\.createWalletUseCase) private var createWalletUseCase: CreateWalletUseCase

    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let unconfirmedPassword = input.fromView.newEncryptionPassword
        let confirmingPassword = input.fromView.confirmedNewEncryptionPassword

        let validator = InputValidator()

        let confirmEncryptionPasswordValidationValue: AnyPublisher<EncryptionPasswordValidator.ValidationResult, Never> = unconfirmedPassword.combineLatest(confirmingPassword).eraseToAnyPublisher()
            .map {
                validator.validateConfirmedEncryptionPassword($0.0, confirmedBy: $0.1)
            }.eraseToAnyPublisher()

        let isContinueButtonEnabled: AnyPublisher<Bool, Never> = confirmEncryptionPasswordValidationValue.map(\.isValid)
            .combineLatest(input.fromView.isHaveBackedUpPasswordCheckboxChecked) { isPasswordConfirmed, isBackedUpChecked in
                isPasswordConfirmed && isBackedUpChecked
            }.eraseToAnyPublisher()

        let activityIndicator = ActivityIndicator()

        [
            input.fromController.leftBarButtonTrigger
                .sink { userDid(.cancel) },

            input.fromView.createWalletTrigger
                .withLatestFrom(confirmEncryptionPasswordValidationValue.map { $0.value?.validPassword }.filterNil()) {
                    $1
                }
                .flatMapLatest {
                    self.createWalletUseCase.createNewWallet(encryptionPassword: $0)
                        .trackActivity(activityIndicator)
                        .replaceErrorWithEmpty()
                }
                .sink { userDid(.createWallet($0)) },
        ].forEach { $0.store(in: &cancellables) }

        let encryptionPasswordValidationTrigger = unconfirmedPassword.mapToVoid().map { true }.merge(with: input.fromView.isEditingNewEncryptionPassword).eraseToAnyPublisher()

        let encryptionPasswordValidation: AnyPublisher<AnyValidation, Never> = encryptionPasswordValidationTrigger.withLatestFrom(
            unconfirmedPassword.map { validator.validateNewEncryptionPassword($0) }
        ) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        // map `editingChanged` to `editingDidBegin`
        let confirmEditingTrigger = confirmingPassword.mapToVoid().map { true }
            .merge(with: input.fromView.isEditingConfirmedEncryptionPassword)
            .eraseToAnyPublisher()

        // encryptionPasswordValidationTrigger used solely to trigger re-evaluation; value discarded
        let confirmEncryptionPasswordValidation: AnyPublisher<AnyValidation, Never> = confirmEditingTrigger
            .combineLatest(encryptionPasswordValidationTrigger)
            .withLatestFrom(confirmEncryptionPasswordValidationValue) {
                EditingValidation(isEditing: $0.0, validation: $1.validation)
            }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        return Output(
            encryptionPasswordPlaceholder: Just(String(localized: .CreateNewWallet
                .encryptionPasswordField(minLength: WalletEncryptionPassword
                    .minimumLength(mode: encryptionPasswordMode))))
                .eraseToAnyPublisher(),
            encryptionPasswordValidation: encryptionPasswordValidation,
            confirmEncryptionPasswordValidation: confirmEncryptionPasswordValidation,
            isContinueButtonEnabled: isContinueButtonEnabled,
            isButtonLoading: activityIndicator.asPublisher()
        )
    }
}

extension CreateNewWalletViewModel {
    struct InputFromView {
        let newEncryptionPassword: AnyPublisher<String, Never>
        let isEditingNewEncryptionPassword: AnyPublisher<Bool, Never>
        let confirmedNewEncryptionPassword: AnyPublisher<String, Never>
        let isEditingConfirmedEncryptionPassword: AnyPublisher<Bool, Never>

        let isHaveBackedUpPasswordCheckboxChecked: AnyPublisher<Bool, Never>
        let createWalletTrigger: AnyPublisher<Void, Never>
    }

    struct Output {
        let encryptionPasswordPlaceholder: AnyPublisher<String, Never>
        let encryptionPasswordValidation: AnyPublisher<AnyValidation, Never>
        let confirmEncryptionPasswordValidation: AnyPublisher<AnyValidation, Never>
        let isContinueButtonEnabled: AnyPublisher<Bool, Never>
        let isButtonLoading: AnyPublisher<Bool, Never>
    }

    struct InputValidator {
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
