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

        let gasPriceValidationResult = input.fromView.gasPriceDidEndEditing
            .withLatestFrom(input.fromView.gasPrice) { $1 }
            .map { validator.validateGasPrice($0) }

        // MARK: - Validated values
        let recipient = recipientAddressValidationResult.map { $0.value }
        let amount = amountValidationResult.map { $0.value }
        let gasPrice = gasPriceValidationResult.map { $0.value }

        let balance = latestBalanceAndNonce.map { $0.balance }.startWith(0)

        let sufficientFundsValidationResult: Driver<InputValidationResult<Amount>> = Driver.combineLatest(amount, gasPrice, balance) {
            guard let amount = $0, let gasPrice = $1, case let balance = $2 else {
                return .invalid(.empty)
            }
            return validator.validate(amount: amount, gasPrice: gasPrice, lessThanBalance: balance)
        }

        let payment: Driver<Payment?> = Driver.combineLatest(
            recipient,
            sufficientFundsValidationResult.map { $0.value },
            gasPrice,
            latestBalanceAndNonce.map { $0.nonce }
        ) {
            guard let to = $0, let amount = $1, let price = $2, case let nonce = $3 else {
                return nil
            }
            return Payment(to: to, amount: amount, gasLimit: .defaultGasLimit, gasPrice: price, nonce: nonce)
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
        let amountValidation = Driver.merge(
            amountValidationResult.distinctUntilChanged().map { $0.errorMessage },
            sufficientFundsValidationResult.map { $0.errorMessage }
        )
        let isSendButtonEnabled = payment.map { $0 != nil }

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balance.map { €.Labels.Balance.value($0.display) },

            recipient: recipient.filterNil().map { $0.checksummedHex },
            recipientAddressValidation: recipientAddressValidationResult.map { $0.errorMessage },

            amount: amount.filterNil().map { $0.display },
            amountValidation: amountValidation,

            gasPricePlaceholder: Driver.just(€.Field.gasPrice(GasPrice.minimum.display)),
            gasPriceValidation: gasPriceValidationResult.map { $0.errorMessage }
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

extension Amount {
    static var defaultGasLimit: Amount {
        return 1
    }
}
