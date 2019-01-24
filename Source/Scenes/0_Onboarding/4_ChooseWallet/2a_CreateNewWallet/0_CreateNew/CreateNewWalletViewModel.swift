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

import Foundation
import RxSwift
import RxCocoa
import Zesame

private typealias € = L10n.Scene.CreateNewWallet
private let encryptionPasswordMode: WalletEncryptionPassword.Mode = .newOrRestorePrivateKey

// MARK: - CreateNewWalletUserAction
enum CreateNewWalletUserAction: TrackableEvent {
    case createWallet(Wallet), cancel

    // Analytics
    var eventName: String {
        switch self {
        case .createWallet: return "createWallet"
        case .cancel: return "cancel"
        }
    }
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
