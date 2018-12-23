//
//  DecryptKeystoreToRevealKeyPairViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxSwift
import RxCocoa

enum DecryptKeystoreToRevealKeyPairUserAction: TrackedUserAction {
    case abort
    case decryptKeystoreReavealing(keyPair: KeyPair)
    // Explicitly implement `eventName` to omitt sensitive data
    var eventName: String {
        switch self {
        case .abort: return "abort"
        case .decryptKeystoreReavealing: return "decryptKeystore"
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

        // MARK: - Validate input (only validate fields when they loose focus)
        let validator = InputValidator()

        let encryptionPassphraseValidationValue = input.fromView.encryptionPassphrase
            .withLatestFrom(wallet) { (passphrase: $0, wallet: $1) }
            .map { validator.validateEncryptionPassphrase($0.passphrase, for: $0.wallet) }

        let encryptionPassphrase = encryptionPassphraseValidationValue.map { $0.value?.validPassphrase }.filterNil()

        bag <~ [
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
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.decryptKeystoreReavealing(keyPair: $0)) })
                .drive(),

            input.fromController.rightBarButtonTrigger
                .do(onNext: { userDid(.abort) })
                .drive()
        ]

        let encryptionPassphrasePlaceHolder = wallet.map { €.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLengthForWallet($0)) }

        return Output(
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            encryptionPassphraseValidation: encryptionPassphraseValidationValue.map { $0.validation },
            isRevealButtonEnabled: encryptionPassphraseValidationValue.map { $0.isValid },
            isRevealButtonLoading: activityIndicator.asDriver()
        )
    }
}

extension DecryptKeystoreToRevealKeyPairViewModel {

    struct InputFromView {
        let encryptionPassphrase: Driver<String>
        let revealTrigger: Driver<Void>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let encryptionPassphraseValidation: Driver<Validation>
        let isRevealButtonEnabled: Driver<Bool>
        let isRevealButtonLoading: Driver<Bool>
    }

    struct InputValidator {

        func validateEncryptionPassphrase(_ passphrase: String, for wallet: Wallet) -> InputValidationResult<WalletEncryptionPassphrase, EncryptionPassphraseValidator.Error> {
            let validator = EncryptionPassphraseValidator(mode: WalletEncryptionPassphrase.modeFrom(wallet: wallet))
            return validator.validate(input: (passphrase: passphrase, confirmingPassphrase: passphrase))
        }
    }
}

