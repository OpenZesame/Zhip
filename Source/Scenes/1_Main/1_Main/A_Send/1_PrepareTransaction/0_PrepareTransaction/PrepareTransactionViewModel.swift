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

        // MARK: - Validate input (only validate fields when they loose focus)
        let validator = InputValidator()

        let recipientAddressValidation = Driver.merge(
            // Validate input from view
            input.fromView.recepientAddress.map { validator.validateRecipient($0) },

            // Address from DeepLinked transaction should be valid
            deepLinkedTransaction.map { .valid($0.recipient) }
        )

        let amountValidation = Driver.merge(
            // Validate input from view
            input.fromView.amountToSend.map { validator.validateAmount($0) },

            // Amount from DeepLinked transaction should be valid
            deepLinkedTransaction.map { .valid($0.amount) }
        )

        let gasPriceValidation = input.fromView.gasPrice.map { validator.validateGasPrice($0) }

        // MARK: - Validated values
        let recipient = recipientAddressValidation.map { $0.value }
        let amountNotBoundByBalance = amountValidation.map { $0.value }
        let gasPrice = gasPriceValidation.map { $0.value }

        let balance = latestBalanceAndNonce.map { $0.balance }

        let sufficientFundsValidationTrigger = Driver.merge(
            // Amount trigger
            Driver.merge(
                input.fromView.amountDidEndEditing,
                deepLinkedTransaction.map { $0.amount }.distinctUntilChanged().mapToVoid()
            ),
            input.fromView.gasPriceDidEndEditing,
            balance.mapToVoid()
        )

        let sufficientFundsValidation: Driver<InputValidationResult<Amount>> = sufficientFundsValidationTrigger.withLatestFrom(
            Driver.combineLatest(amountNotBoundByBalance, gasPrice, balance) {
                guard let amount = $0, let gasPrice = $1, case let balance = $2 else {
                    return .invalid(.empty)
                }
                return validator.validate(amount: amount, gasPrice: gasPrice, lessThanBalance: balance)
            }
        )

        let amount = sufficientFundsValidation.map { $0.value }
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
        let amountErrorMessage = Driver.zip(
            sufficientFundsValidation.map { $0.errorMessage },
            amountValidation.map { $0.errorMessage }
        ) { $0 ?? $1 }

        let gasPriceErrorMessage = input.fromView.gasPriceDidEndEditing
            .withLatestFrom(gasPriceValidation.map { $0.errorMessage }) { $1 }

        let recipientErrorMessage = input.fromView.recipientAddressDidEndEditing
            .withLatestFrom(recipientAddressValidation.map { $0.errorMessage }) { $1 }

        let balanceFormatted = balance.map { €.Labels.Balance.value($0.display) }
        let recipientFormatted = recipient.filterNil().map { $0.checksummedHex }
        let amountFormatted = amount.filterNil().map { $0.display }

        let isSendButtonEnabled = payment.map { $0 != nil }

        let gasPricePlaceholder = Driver.just(€.Field.gasPrice(GasPrice.minimum.display))

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balanceFormatted,

            recipient: recipientFormatted,
            recipientAddressValidation: recipientErrorMessage,

            amount: amountFormatted,
            amountValidation: amountErrorMessage,

            gasPricePlaceholder: gasPricePlaceholder,
            gasPriceValidation: gasPriceErrorMessage
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
        let recipientAddressValidation: Driver<String?>

        let amount: Driver<String>
        let amountValidation: Driver<String?>

        let gasPricePlaceholder: Driver<String>
        let gasPriceValidation: Driver<String?>
    }
}

// MARK: - Field Validation
extension PrepareTransactionViewModel {
    struct InputValidator {
        private let addressValidator = AddressValidator()
        private let amountValidator = AmountValidator()
        private let gasPriceValidator = GasPriceValidator()
        private let sufficientFundsValidator = SufficientFundsValidator()

        func validateRecipient(_ recipient: String?) -> InputValidationResult<Address> {
            return addressValidator.validate(input: recipient)
        }

        func validate(amount: Amount, gasPrice: GasPrice, lessThanBalance balance: Amount) -> InputValidationResult<Amount> {
            return sufficientFundsValidator.validate(input: (amount, gasPrice, balance))
        }

        func validateAmount(_ amount: String) -> InputValidationResult<Amount> {
            return amountValidator.validate(input: amount)
        }

        func validateGasPrice(_ gasPrice: String?) -> InputValidationResult<GasPrice> {
            return gasPriceValidator.validate(input: gasPrice)
        }
    }
}
