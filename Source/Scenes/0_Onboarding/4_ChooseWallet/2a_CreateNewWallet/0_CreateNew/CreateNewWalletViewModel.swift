//
//  CreateNewWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

private typealias € = L10n.Scene.CreateNewWallet
private let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .new

// MARK: - CreateNewWalletUserAction
enum CreateNewWalletUserAction: TrackedUserAction {
     case createWallet(Wallet)
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

        let validator = InputValidator()

        let confirmEncryptionPassphraseValidationValue = Driver.combineLatest(
            input.fromView.newEncryptionPassphrase,
            input.fromView.confirmedNewEncryptionPassphrase
        ) { (passphrase: $0, confirming: $1) }.map {
            validator.validateConfirmedEncryptionPassphrase($0.passphrase, confirmedBy: $0.confirming)
        }.filter {
            if case .invalid(.error(.passphraseIsTooShort)) = $0 {
                // Filter out (exclude) the error `passphraseIsTooShort`, covered by encryptionPassphraseValidation
                return false
            } else {
                return true
            }
        }

        let confirmedEncryptionPassphrase = confirmEncryptionPassphraseValidationValue.map { $0.value?.validPassphrase }.filterNil()

        let isContinueButtonEnabled = Driver.combineLatest(confirmEncryptionPassphraseValidationValue.map { $0.isValid }, input.fromView.isHaveBackedUpPassphraseCheckboxChecked) { $0 && $1 }

        let activityIndicator = ActivityIndicator()

        bag <~ [
            input.fromView.createWalletTrigger.withLatestFrom(confirmedEncryptionPassphrase) { $1 }
                .flatMapLatest {
                    self.useCase.createNewWallet(encryptionPassphrase: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.createWallet($0)) })
                .drive()
        ]

        let encryptionPassphraseValidationValue = input.fromView.newEncryptionPassphrase.map {
            validator.validateNewEncryptionPassphrase($0)
        }

        let encryptionPassphraseValidationTrigger = Driver.merge(
            input.fromView.newEncryptionPassphrase.mapToVoid().map { true },
            input.fromView.isEditingNewEncryptionPassphrase
        )

        let encryptionPassphraseValidation: Driver<Validation> = encryptionPassphraseValidationTrigger.withLatestFrom(encryptionPassphraseValidationValue) {
            (isEditingPassphrase: $0, validationValue: $1)
        }.map {
            switch ($0.isEditingPassphrase, $0.validationValue) {
            // Always indicate valid
            case (_, .valid): return .valid
            // Always validate when stop editing
            case (false, _): return $0.validationValue.validation
            // Convert invalid -> empty when starting editing
            case (true, .invalid): return .empty
            }
        }

        let confirmEncryptionPassphraseValidation: Driver<Validation> = Driver.combineLatest(
            Driver.merge(
                // map editChanges to `isEditing:true`
                input.fromView.confirmedNewEncryptionPassphrase.mapToVoid().map { true },
                input.fromView.isEditingConfirmedEncryptionPassphrase
            ),
            encryptionPassphraseValidationTrigger // used for triggering, but value never used
        ).withLatestFrom(confirmEncryptionPassphraseValidationValue) {
            (isEditingConfirmPassphrase: $0.1, validationValue: $1)
        }.map {
            switch ($0.isEditingConfirmPassphrase, $0.validationValue) {
            // Always indicate valid
            case (_, .valid): return .valid
            // Always validate when stop editing
            case (false, _): return $0.validationValue.validation
            // Convert invalid -> empty when starting editing
            case (true, .invalid): return .empty
            }
        }

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
        let encryptionPassphraseValidation: Driver<Validation>
        let confirmEncryptionPassphraseValidation: Driver<Validation>
        let isContinueButtonEnabled: Driver<Bool>
        let isButtonLoading: Driver<Bool>
    }

    struct InputValidator {

        func validateNewEncryptionPassphrase(_ passphrase: String) -> InputValidationResult<WalletEncryptionPassphrase, EncryptionPassphraseValidator.Error> {
            let validator = EncryptionPassphraseValidator(mode: encryptionPassphraseMode)
            return validator.validate(input: (passphrase, passphrase))
        }

        func validateConfirmedEncryptionPassphrase(_ passphrase: String, confirmedBy confirming: String) -> InputValidationResult<WalletEncryptionPassphrase, EncryptionPassphraseValidator.Error> {
            let validator = EncryptionPassphraseValidator(mode: encryptionPassphraseMode)
            return validator.validate(input: (passphrase, confirming))
        }
    }
}

extension Bool {
    static var irrelevant: Bool {
        return Bool.random()
    }
}
