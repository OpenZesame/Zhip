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
private let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .newOrRestorePrivateKey

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

        let unconfirmedPassphrase = input.fromView.newEncryptionPassphrase
        let confirmingPassphrase = input.fromView.confirmedNewEncryptionPassphrase

        let validator = InputValidator()

        let confirmEncryptionPassphraseValidationValue = Driver.combineLatest(unconfirmedPassphrase, confirmingPassphrase)
            .map {
                validator.validateConfirmedEncryptionPassphrase($0.0, confirmedBy: $0.1)
            }

        let isContinueButtonEnabled = Driver.combineLatest(
            confirmEncryptionPassphraseValidationValue.map { $0.isValid },
            input.fromView.isHaveBackedUpPassphraseCheckboxChecked
        ) { (isPassphraseConfirmed, isBackedUpChecked) in
            isPassphraseConfirmed && isBackedUpChecked
        }

        let activityIndicator = ActivityIndicator()

        bag <~ [
            input.fromController.leftBarButtonTrigger
                .do(onNext: { userDid(.cancel) })
                .drive(),

            input.fromView.createWalletTrigger
                .withLatestFrom(confirmEncryptionPassphraseValidationValue.map { $0.value?.validPassphrase }.filterNil()) { $1 }
                .flatMapLatest {
                    self.useCase.createNewWallet(encryptionPassphrase: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.createWallet($0)) })
                .drive()
        ]

        let encryptionPassphraseValidationTrigger = Driver.merge(
            unconfirmedPassphrase.mapToVoid().map { true },
            input.fromView.isEditingNewEncryptionPassphrase
        )

        let encryptionPassphraseValidation: Driver<AnyValidation> = encryptionPassphraseValidationTrigger.withLatestFrom(
            unconfirmedPassphrase.map { validator.validateNewEncryptionPassphrase($0) }
        ) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        let confirmEncryptionPassphraseValidation: Driver<AnyValidation> = Driver.combineLatest(
            Driver.merge(
                // map `editingChanged` to `editingDidBegin`
                confirmingPassphrase.mapToVoid().map { true },
                input.fromView.isEditingConfirmedEncryptionPassphrase
            ),
            encryptionPassphraseValidationTrigger // used for triggering, but value never used
        ).withLatestFrom(confirmEncryptionPassphraseValidationValue) {
            EditingValidation(isEditing: $0.0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit()

        return Output(
            encryptionPassphrasePlaceholder: Driver.just(€.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode))),
            encryptionPassphraseValidation: encryptionPassphraseValidation,
            confirmEncryptionPassphraseValidation: confirmEncryptionPassphraseValidation,
            isContinueButtonEnabled: isContinueButtonEnabled,
            isButtonLoading: activityIndicator.asDriver()
        )
    }
}

extension CreateNewWalletViewModel {

    struct InputFromView {
        let newEncryptionPassphrase: Driver<String>
        let isEditingNewEncryptionPassphrase: Driver<Bool>
        let confirmedNewEncryptionPassphrase: Driver<String>
        let isEditingConfirmedEncryptionPassphrase: Driver<Bool>
        
        let isHaveBackedUpPassphraseCheckboxChecked: Driver<Bool>
        let createWalletTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let encryptionPassphraseValidation: Driver<AnyValidation>
        let confirmEncryptionPassphraseValidation: Driver<AnyValidation>
        let isContinueButtonEnabled: Driver<Bool>
        let isButtonLoading: Driver<Bool>
    }

    struct InputValidator {

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
