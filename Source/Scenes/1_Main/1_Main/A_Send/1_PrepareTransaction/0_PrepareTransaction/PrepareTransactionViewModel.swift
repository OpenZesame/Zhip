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
    case scanQRCode
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
    private let deepLinkedTransaction: Driver<TransactionIntent>

    init(walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase, deepLinkedTransaction: Driver<TransactionIntent>) {
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

        let balance = latestBalanceAndNonce.map { $0.balance }.startWith(0)

        // MARK: - Validate input (only validate fields when they loose focus)
        let validator = InputValidator()

        let recipientAddressValidationValue = Driver.merge(
            // Validate input from view
            input.fromView.recepientAddress.map { validator.validateRecipient($0) },

            // Address from DeepLinked transaction should be valid
            deepLinkedTransaction.map { .valid($0.recipient) }
        )

        // This is not quite optimal, we should read from gasPrice field
        let maxAmountBoundByBalanceAndMinGasPrice: Driver<Amount?> = input.fromView.maxAmountTrigger.withLatestFrom(balance).map {
            guard case let balanceMinusOne = $0.value - 1, balanceMinusOne > 0 else { return nil }
            return try? Amount(significand: balanceMinusOne)
        }

        let amountValidationValue = Driver.merge(
            // Validate input from view
            input.fromView.amountToSend.map { validator.validateAmount($0) },

            // Amount from DeepLinked transaction should be valid
            deepLinkedTransaction.map { .valid($0.amount) },

            maxAmountBoundByBalanceAndMinGasPrice.filterNil().map { .valid($0) }
        )

        let gasPriceValidationValue = input.fromView.gasPrice.map { validator.validateGasPrice($0) }

        // MARK: - Validated values
        let recipient = recipientAddressValidationValue.map { $0.value }


        let amountNotBoundByBalance = amountValidationValue.map { $0.value }

        let gasPrice = gasPriceValidationValue.map { $0.value }

        let sufficientFundsValidationTrigger = Driver.merge(
            // Amount trigger
            Driver.merge(
                input.fromView.amountDidEndEditing,
                input.fromView.maxAmountTrigger,
                deepLinkedTransaction.map { $0.amount }.distinctUntilChanged().mapToVoid()
            ),
            input.fromView.gasPriceDidEndEditing,
            balance.mapToVoid()
        )

        let sufficientFundsValidationValue: Driver<SufficientFundsValidator.Result> = sufficientFundsValidationTrigger.withLatestFrom(
            Driver.combineLatest(amountNotBoundByBalance, gasPrice, balance) {
                guard let amount = $0, let gasPrice = $1, case let balance = $2 else {
                    return .invalid(.empty)
                }
                return validator.validate(amount: amount, gasPrice: gasPrice, lessThanBalance: balance)
            }
        )

        let amount = sufficientFundsValidationValue.map { $0.value }
        let nonce = latestBalanceAndNonce.map { $0.nonce }.startWith(0)

        let payment: Driver<Payment?> = Driver.combineLatest(recipient, amount, gasPrice, nonce) {
            guard let to = $0, let amount = $1, let price = $2, case let nonce = $3 else {
                return nil
            }
            return Payment(to: to, amount: amount, gasLimit: 1, gasPrice: price, nonce: nonce)
        }

        // Setup navigation
        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .cancel) })
                .drive(),

            input.fromView.scanQRTrigger
                .do(onNext: { userIntends(to: .scanQRCode) })
                .drive(),

            input.fromView.sendTrigger.withLatestFrom(payment.filterNil())
                .do(onNext: { userIntends(to: .signPayment($0)) })
                .drive()
        ]

        // Format output
        let formatter = Formatter()

        let amountValidation: Driver<Validation> = Driver.zip(
            sufficientFundsValidationValue.map { $0.validation },
            amountValidationValue.map { $0.validation }
        ) {
            switch ($0, $1) {
            case (.valid, .valid): return Validation.valid
            case (.empty, .empty), (.empty, .valid): return Validation.empty
            case (.error, _): return $0
            case (_, .error): return $1
            default: incorrectImplementation("Should have handled all cases above, sufficientFundsValidationValue: \($0), amountValidationValue: \($1)")
            }
        }

        let gasPriceValidation = input.fromView.gasPriceDidEndEditing
            .withLatestFrom(gasPriceValidationValue.map { $0.validation }) { $1 }

        let recipientAddressValidation = input.fromView.recipientAddressDidEndEditing
            .withLatestFrom(recipientAddressValidationValue.map { $0.validation }) { $1 }

        let balanceFormatted = balance.map { formatter.format(amount: $0) }
        let recipientFormatted = recipient.filterNil().map { $0.checksummedHex }

        let amountFormatted = amount.filterNil().map { $0.display }

        let isSendButtonEnabled = payment.map { $0 != nil }

        let gasPricePlaceholder = Driver.just(€.Field.gasPrice(GasPrice.minimum.display))

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balanceFormatted,

            recipient: recipientFormatted,
            recipientAddressValidation: recipientAddressValidation,

            amount: amountFormatted,
            amountValidation: amountValidation,

            gasPricePlaceholder: gasPricePlaceholder,
            gasPriceValidation: gasPriceValidation
        )
    }
}

extension ExpressibleByAmount {
    var display: String {
        return Int(significand).description
    }
}

extension PrepareTransactionViewModel {

    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let scanQRTrigger: Driver<Void>
        let maxAmountTrigger: Driver<Void>
        let sendTrigger: Driver<Void>

        let recepientAddress: Driver<String>
        let recipientAddressDidEndEditing: Driver<Void>

        let amountToSend: Driver<String>
        let amountDidEndEditing: Driver<Void>

        let gasPrice: Driver<String>
        let gasPriceDidEndEditing: Driver<Void>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let isSendButtonEnabled: Driver<Bool>
        let balance: Driver<String>

        let recipient: Driver<String>
        let recipientAddressValidation: Driver<Validation>

        let amount: Driver<String>
        let amountValidation: Driver<Validation>

        let gasPricePlaceholder: Driver<String>
        let gasPriceValidation: Driver<Validation>
    }
}

// MARK: - Field Validation
extension PrepareTransactionViewModel {
    struct InputValidator {
        private let addressValidator = AddressValidator()
        private let amountValidator = AmountValidator()
        private let gasPriceValidator = GasPriceValidator()
        private let sufficientFundsValidator = SufficientFundsValidator()

        func validateRecipient(_ recipient: String?) -> InputValidationResult<Address, AddressValidator.Error> {
            return addressValidator.validate(input: recipient)
        }

        func validate(amount: Amount, gasPrice: GasPrice, lessThanBalance balance: Amount) -> InputValidationResult<Amount, SufficientFundsValidator.Error> {
            return sufficientFundsValidator.validate(input: (amount, gasPrice, balance))
        }

        func validateAmount(_ amount: String) -> InputValidationResult<Amount, AmountValidator.Error> {
            return amountValidator.validate(input: amount)
        }

        func validateGasPrice(_ gasPrice: String?) -> InputValidationResult<GasPrice, GasPriceValidator.Error> {
            return gasPriceValidator.validate(input: gasPrice)
        }
    }

    struct Formatter {
        func format(amount: Amount) -> String {
            let amountString = amount.display.inserting(string: " ", every: 3)
            return "\(amountString) \(L10n.Generic.zils)"
        }
    }
}
