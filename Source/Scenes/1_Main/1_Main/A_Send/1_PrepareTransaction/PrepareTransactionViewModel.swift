//
//  PrepareTransactionViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

// MARK: - PrepareTransactionUserAction
enum PrepareTransactionUserAction: TrackedUserAction {
    case cancel
    case signPayment(Payment)
}

// MARK: - PrepareTransactionViewModel
private typealias € = L10n.Scene.PrepareTransaction
final class PrepareTransactionViewModel: BaseViewModel<
    PrepareTransactionUserAction,
    PrepareTransactionViewModel.InputFromView,
    PrepareTransactionViewModel.Output
> {
    private let transactionUseCase: TransactionsUseCase
    private let walletUseCase: WalletUseCase
    private let deepLinkedTransaction: Driver<Transaction>

    init(walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase, deepLinkedTransaction: Driver<Transaction>) {
        self.walletUseCase = walletUseCase
        self.transactionUseCase = transactionUseCase
        self.deepLinkedTransaction = deepLinkedTransaction
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        let wallet = walletUseCase.wallet.filterNil().asDriverOnErrorReturnEmpty()
        let activityIndicator = ActivityIndicator()

        let fetchTrigger = Driver.merge(
            input.fromView.pullToRefreshTrigger,
            wallet.mapToVoid()
        )

        // Fetch latest balance from API
        let latestBalanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest {
            self.transactionUseCase
                .getBalance(for: $0.address)
                .trackActivity(activityIndicator)
                .asDriverOnErrorReturnEmpty()
        }

        // MARK: - Validate input (only validate fields when they loose focus)
        let validator = InputValidator()

        let recipientAddressValidationResult = Driver.merge(
            input.fromView.recipientAddressDidEndEditing
                .withLatestFrom(input.fromView.recepientAddress) { $1 }
                // Validate input from view
                .map { validator.validateRecipient($0) },

            // Address from DeepLinked transaction should be valid
            deepLinkedTransaction.map { .valid($0.recipient) }
        )

        let amountValidationResult = Driver.merge(
            input.fromView.amountDidEndEditing
                .withLatestFrom(input.fromView.amountToSend) { $1 }
                // Validate input from view
                .map { validator.validateAmount($0) },

            // Amount from DeepLinked transaction should be valid
            deepLinkedTransaction.map { .valid($0.amount) }
        )

        let gasLimitValidationResult = input.fromView.gasLimitDidEndEditing
            .withLatestFrom(input.fromView.gasLimit) { $1 }
            .map { validator.validateGasLimit($0) }

        let gasPriceValidationResult = input.fromView.gasPriceDidEndEditing
            .withLatestFrom(input.fromView.gasPrice) { $1 }
            .map { validator.validateGasPrice($0) }

        // MARK: - Validated values
        let recipient = recipientAddressValidationResult.map { $0.value }.filterNil()
        let amount = amountValidationResult.map { $0.value }.filterNil()

        let payment = Driver.combineLatest(
            recipient,
            amount,
            gasLimitValidationResult.map { $0.value }.filterNil(),
            gasPriceValidationResult.map { $0.value }.filterNil(),
            latestBalanceAndNonce.map { $0.nonce }
        ) {
            Payment(to: $0, amount: $1, gasLimit: $2, gasPrice: $3, nonce: $4)
        }

        let isSendButtonEnabled = payment.map { $0 != nil }

        // Setup navigation
        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .cancel) })
                .drive(),

            input.fromView.sendTrigger.withLatestFrom(payment.filterNil())
                .do(onNext: { userIntends(to: .signPayment($0)) })
                .drive()
        ]

        // Format output
        let latestBalanceOrZero = latestBalanceAndNonce.map { $0.balance }.startWith(0)

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: latestBalanceOrZero.map { €.Labels.Balance.value($0.amount.description) },

            recipient: recipient.map { $0.checksummedHex },
            recipientAddressValidation: recipientAddressValidationResult.map { $0.errorMessage },

            amount: amount.map { $0.description },
            amountValidation: amountValidationResult.map { $0.errorMessage },

            gasPriceValidation: gasPriceValidationResult.map { $0.errorMessage },
            gasLimitValidation: gasLimitValidationResult.map { $0.errorMessage }
        )
    }
}

extension PrepareTransactionViewModel {

    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let sendTrigger: Driver<Void>

        let recepientAddress: Driver<String>
        let recipientAddressDidEndEditing: Driver<Void>

        let amountToSend: Driver<String>
        let amountDidEndEditing: Driver<Void>

        let gasLimit: Driver<String>
        let gasLimitDidEndEditing: Driver<Void>

        let gasPrice: Driver<String>
        let gasPriceDidEndEditing: Driver<Void>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let isSendButtonEnabled: Driver<Bool>
        let balance: Driver<String>

        let recipient: Driver<String>
        let recipientAddressValidation: Driver<String?>

        let amount: Driver<String>
        let amountValidation: Driver<String?>

        let gasPriceValidation: Driver<String?>
        let gasLimitValidation: Driver<String?>
    }
}

// MARK: - Field Validation
extension PrepareTransactionViewModel {
    struct InputValidator {
        private let addressValidator = AddressValidator()
        private let amountValidator = AmountValidator()

        func validateRecipient(_ recipient: String?) -> InputValidationResult<Address> {
            return addressValidator.validate(input: recipient)
        }

        func validateAmount(_ amount: String) -> InputValidationResult<Double> {
            return amountValidator.validate(string: amount)
        }

        func validateGasLimit(_ gasLimit: String?) -> InputValidationResult<Double> {
            return amountValidator.validate(string: gasLimit)
        }

        func validateGasPrice(_ gasPrice: String?) -> InputValidationResult<Double> {
            return amountValidator.validate(string: gasPrice)
        }
    }
}
