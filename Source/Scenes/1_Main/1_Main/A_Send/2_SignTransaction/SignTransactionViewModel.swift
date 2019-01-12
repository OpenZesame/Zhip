//
//  SignTransactionViewModel.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-17.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

enum SignTransactionUserAction: TrackableEvent {
    case sign(TransactionResponse)

    var eventName: String {
        switch self {
        case .sign: return "sign"
        }
    }
}

final class SignTransactionViewModel: BaseViewModel<
    SignTransactionUserAction,
    SignTransactionViewModel.InputFromView,
    SignTransactionViewModel.Output
> {

    private let transactionUseCase: TransactionsUseCase
    private let payment: Payment
    private let walletUseCase: WalletUseCase

    init(paymentToSign: Payment, walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase) {
        self.payment = paymentToSign
        self.walletUseCase = walletUseCase
        self.transactionUseCase = transactionUseCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userDid(_ userAction: NavigationStep) {
            navigator.next(userAction)
        }

        guard let _wallet = walletUseCase.loadWallet() else { incorrectImplementation("Should have wallet") }
        let _payment = payment

        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()

        // MARK: - Validate input
        let validator = InputValidator()

        let encryptionPassphraseValidationValue = input.fromView.encryptionPassphrase
            .map { validator.validateEncryptionPassphrase($0, for: _wallet) }

        let encryptionPassphrase = encryptionPassphraseValidationValue.map { $0.value?.validPassphrase }.filterNil()

        bag <~ [
            input.fromView.signAndSendTrigger
                .withLatestFrom(encryptionPassphrase)
                .flatMapLatest {
                    self.transactionUseCase.sendTransaction(for: _payment, wallet: _wallet, encryptionPassphrase: $0)
                        .trackActivity(activityIndicator)
                        .trackError(errorTracker)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.sign($0)) })
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
                WalletEncryptionPassphrase.Error.incorrectPassphraseErrorFrom(error: $0)
        }

        let isSignButtonEnabled = encryptionPassphraseValidation.map { $0.isValid }

        return Output(
            isSignButtonEnabled: isSignButtonEnabled,
            isSignButtonLoading: activityIndicator.asDriver(),
            encryptionPassphraseValidation: encryptionPassphraseValidation,
            inputBecomeFirstResponder: input.fromController.viewDidAppear
        )
    }

}

extension SignTransactionViewModel {

    struct InputFromView {
        let encryptionPassphrase: Driver<String>
        let isEditingEncryptionPassphrase: Driver<Bool>
        let signAndSendTrigger: Driver<Void>
    }

    struct Output {
        let isSignButtonEnabled: Driver<Bool>
        let isSignButtonLoading: Driver<Bool>
        let encryptionPassphraseValidation: Driver<AnyValidation>
        let inputBecomeFirstResponder: Driver<Void>
    }

    struct InputValidator {

        func validateEncryptionPassphrase(_ passphrase: String, for wallet: Wallet) -> EncryptionPassphraseValidator.Result {
            let validator = EncryptionPassphraseValidator(mode: WalletEncryptionPassphrase.modeFrom(wallet: wallet))
            return validator.validate(input: (passphrase: passphrase, confirmingPassphrase: passphrase))
        }
    }
}
