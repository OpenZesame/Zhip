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

import Foundation
import RxSwift
import RxCocoa
import Zesame

private typealias € = L10n.Scene.CreateNewWallet
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
> {
    private let useCase: WalletUseCase

    init(useCase: WalletUseCase) {
        self.useCase = useCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        let unconfirmedPassword = input.fromView.newEncryptionPassword
        let confirmingPassword = input.fromView.confirmedNewEncryptionPassword

        let validator = InputValidator()

        let confirmEncryptionPasswordValidationValue = Driver.combineLatest(unconfirmedPassword, confirmingPassword)
            .map {
                validator.validateConfirmedEncryptionPassword($0.0, confirmedBy: $0.1)
            }

        let isContinueButtonEnabled = Driver.combineLatest(
            confirmEncryptionPasswordValidationValue.map { $0.isValid },
            input.fromView.isHaveBackedUpPasswordCheckboxChecked
        ) { (isPasswordConfirmed, isBackedUpChecked) in
            isPasswordConfirmed && isBackedUpChecked
        }

        let activityIndicator = ActivityIndicator()

        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            input.fromView.createWalletTrigger
                .withLatestFrom(confirmEncryptionPasswordValidationValue.map { $0.value?.validPassword }.filterNil()) { $1 }
                .flatMapLatest {
                    self.useCase.createNewWallet(encryptionPassword: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.createWallet($0)) })
                .drive()
        ]

        let encryptionPasswordValidationTrigger = Driver.merge(
            unconfirmedPassword.mapToVoid().map { true },
            input.fromView.isEditingNewEncryptionPassword
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
                input.fromView.isEditingConfirmedEncryptionPassword
            ),
            encryptionPasswordValidationTrigger // used for triggering, but value never used
        ).withLatestFrom(confirmEncryptionPasswordValidationValue) {
            EditingValidation(isEditing: $0.0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        return Output(
            encryptionPasswordPlaceholder: Driver.just(€.Field.encryptionPassword(WalletEncryptionPassword.minimumLenght(mode: encryptionPasswordMode))),
            encryptionPasswordValidation: encryptionPasswordValidation,
            confirmEncryptionPasswordValidation: confirmEncryptionPasswordValidation,
            isContinueButtonEnabled: isContinueButtonEnabled,
            isButtonLoading: activityIndicator.asDriver()
        )
    }
}

extension CreateNewWalletViewModel {

    struct InputFromView {
        let newEncryptionPassword: Driver<String>
        let isEditingNewEncryptionPassword: Driver<Bool>
        let confirmedNewEncryptionPassword: Driver<String>
        let isEditingConfirmedEncryptionPassword: Driver<Bool>
        
        let isHaveBackedUpPasswordCheckboxChecked: Driver<Bool>
        let createWalletTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPasswordPlaceholder: Driver<String>
        let encryptionPasswordValidation: Driver<AnyValidation>
        let confirmEncryptionPasswordValidation: Driver<AnyValidation>
        let isContinueButtonEnabled: Driver<Bool>
        let isButtonLoading: Driver<Bool>
    }

    struct InputValidator {

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
