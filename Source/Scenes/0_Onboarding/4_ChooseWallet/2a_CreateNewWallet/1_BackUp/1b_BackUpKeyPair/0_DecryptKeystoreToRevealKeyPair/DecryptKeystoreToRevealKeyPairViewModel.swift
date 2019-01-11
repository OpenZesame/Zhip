//
//  DecryptKeystoreToRevealKeyPairViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxSwift
import RxCocoa

enum DecryptKeystoreToRevealKeyPairUserAction: TrackableEvent {
    case dismiss
    case decryptKeystoreReavealing(keyPair: KeyPair)

    // Analytics
    var eventName: String {
        switch self {
        case .dismiss: return "dismiss"
        case .decryptKeystoreReavealing: return "decryptKeystoreReavealing"
        }
    }
}

private typealias € = L10n.Scene.DecryptKeystoreToRevealKeyPair

final class DecryptKeystoreToRevealKeyPairViewModel: BaseViewModel<
    DecryptKeystoreToRevealKeyPairUserAction,
    DecryptKeystoreToRevealKeyPairViewModel.InputFromView,
    DecryptKeystoreToRevealKeyPairViewModel.Output
> {

    private let useCase: WalletUseCase
    private let wallet: Driver<Wallet>

    init(useCase: WalletUseCase, wallet: Driver<Wallet>) {
        self.useCase = useCase
        self.wallet = wallet
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ step: NavigationStep) {
            navigator.next(step)
        }

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        // MARK: - Validate input
        let validator = InputValidator()

        let encryptionPassphraseValidationValue = input.fromView.encryptionPassphrase
            .withLatestFrom(wallet) { (passphrase: $0, wallet: $1) }
            .map { validator.validateEncryptionPassphrase($0.passphrase, for: $0.wallet) }

        let encryptionPassphrase = encryptionPassphraseValidationValue.map { $0.value?.validPassphrase }.filterNil()

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.dismiss) })
                .drive(),

            input.fromView.revealTrigger
                .withLatestFrom(
                    Driver.combineLatest(
                        wallet,
                        encryptionPassphrase
                    )
                ) { (wallet: $1.0, passphrase: $1.1) }
                .flatMapLatest { [unowned useCase] in
                    useCase.extractKeyPairFrom(wallet: $0.wallet, encryptedBy: $0.passphrase)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.decryptKeystoreReavealing(keyPair: $0)) })
                .drive()
        ]

        let encryptionPassphraseValidation = Driver.merge(
            // map `editingChanged` to `editingDidBegin`
            input.fromView.encryptionPassphrase.mapToVoid().map { true },
            input.fromView.isEditingEncryptionPassphrase
        ).withLatestFrom(encryptionPassphraseValidationValue) {
            EditingValidation(isEditing: $0, validation: $1.validation)
        }.eagerValidLazyErrorTurnedToEmptyOnEdit(
            directlyDisplayErrorsTrackedBy: errorTracker
        ) {
            WalletEncryptionPassphrase.Error.incorrectPassphraseErrorFrom(error: $0, backingUpWalletJustCreated: true)
        }

        return Output(
            encryptionPassphraseValidation: encryptionPassphraseValidation,
            isRevealButtonEnabled: encryptionPassphraseValidationValue.map { $0.isValid },
            isRevealButtonLoading: activityIndicator.asDriver()
        )
    }
}

extension DecryptKeystoreToRevealKeyPairViewModel {

    struct InputFromView {
        let encryptionPassphrase: Driver<String>
        let isEditingEncryptionPassphrase: Driver<Bool>
        let revealTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPassphraseValidation: Driver<AnyValidation>
        let isRevealButtonEnabled: Driver<Bool>
        let isRevealButtonLoading: Driver<Bool>
    }

    struct InputValidator {

        func validateEncryptionPassphrase(_ passphrase: String, for wallet: Wallet) -> Validation<WalletEncryptionPassphrase, EncryptionPassphraseValidator.Error> {
            let validator = EncryptionPassphraseValidator(mode: WalletEncryptionPassphrase.modeFrom(wallet: wallet))
            return validator.validate(input: (passphrase: passphrase, confirmingPassphrase: passphrase))
        }
    }
}

