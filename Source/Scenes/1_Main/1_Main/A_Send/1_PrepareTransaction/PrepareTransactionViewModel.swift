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

        let fromView = input.fromView

        let fetchBalanceSubject = BehaviorSubject<Void>(value: ())

        let activityIndicator = ActivityIndicator()

        let fetchTrigger = Driver.merge(fromView.pullToRefreshTrigger, fetchBalanceSubject.asDriverOnErrorReturnEmpty(), wallet.mapToVoid())

        let balanceResponse: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest {
            self.transactionUseCase
                .getBalance(for: $0.address)
                .trackActivity(activityIndicator)
                .asDriverOnErrorReturnEmpty()
        }

        let zeroBalance = wallet.map { WalletBalance(wallet: $0) }

        let walletBalance: Driver<WalletBalance> = Driver.combineLatest(wallet, balanceResponse) {
            WalletBalance(wallet: $0, balance: $1.balance, nonce: $1.nonce)
        }

        let balance = Driver.merge(zeroBalance, walletBalance)

        let recipientFromField = fromView.recepientAddress.map {
            try? Address(hexString: $0)
        }

        let recipientFromDeepLinkedTransaction = deepLinkedTransaction.map { $0.recipient }

        let recipient = Driver.merge(recipientFromField.filterNil(), recipientFromDeepLinkedTransaction)
        let amountFromDeepLinkedTransaction = deepLinkedTransaction.map { $0.amount }
        let amount = Driver.merge(fromView.amountToSend.map { Double($0) }.filterNil(), amountFromDeepLinkedTransaction)
        let gasLimit = fromView.gasLimit.map { Double($0) }.filterNil()
        let gasPrice = fromView.gasPrice.map { Double($0) }.filterNil()

        let payment = Driver.combineLatest(recipient, amount, gasLimit, gasPrice, balanceResponse) {
            Payment(to: $0, amount: $1, gasLimit: $2, gasPrice: $3, nonce: $4.nonce)
        }

        let isSendButtonEnabled = payment.map { $0 != nil }

        let validator = InputValidator()

        let recipientAddressValidation = Driver.merge(
            // Validate input from view
            input.fromView.recepientAddress.map { validator.validateRecipient($0) },
            // All addresses from DeepLinked recipient are always valid
            recipientFromDeepLinkedTransaction.map { InputValidationResult.valid($0.checksummedHex) }
        )

        let amountValidation = Driver.merge(
            input.fromView.amountToSend,
            amountFromDeepLinkedTransaction.map { $0.description }
        ).map { validator.validateAmount($0) }

        let gasLimitValidation = fromView.gasLimit.map { validator.validateGasLimit($0) }
        let gasPriceValidation = fromView.gasPrice.map { validator.validateGasPrice($0) }

        // Only validate when the field loses focus
        let recipientAddressValidationResult = fromView.recipientAddressDidEndEditing.withLatestFrom(recipientAddressValidation) { $1 }
        let amountValidationResult = fromView.amountDidEndEditing.withLatestFrom(amountValidation) { $1 }
        let gasLimitValidationResult = fromView.gasLimitDidEndEditing.withLatestFrom(gasLimitValidation) { $1 }
        let gasPriceValidationResult = fromView.gasPriceDidEndEditing.withLatestFrom(gasPriceValidation) { $1 }

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .cancel) })
                .drive(),

            input.fromView.sendTrigger.withLatestFrom(payment.filterNil())
                .do(onNext: { userIntends(to: .signPayment($0)) })
                .drive()
        ]

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balance.map { €.Labels.Balance.value($0.balance.amount.description) },

            recipient: recipient.map { $0.checksummedHex },
            recipientAddressValidationResult: recipientAddressValidationResult,

            amount: amountFromDeepLinkedTransaction.map { $0.description },
            amountValidationResult: amountValidationResult,

            gasPriceValidationResult: gasPriceValidationResult,
            gasLimitValidationResult: gasLimitValidationResult
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
        let recipientAddressValidationResult: Driver<TextInputValidation>

        let amount: Driver<String>
        let amountValidationResult: Driver<InputToDoubleValidation>

        let gasPriceValidationResult: Driver<InputToDoubleValidation>
        let gasLimitValidationResult: Driver<InputToDoubleValidation>
    }
}

// MARK: - Field Validation
import Validator
typealias TextInputValidation = InputValidationResult<String>
typealias InputToDoubleValidation = InputValidationResult<Double>
extension PrepareTransactionViewModel {
    struct InputValidator {
        private let addressValidator = AddressValidator()
        private let amountValidator = AmountValidator()

        func validateRecipient(_ recipient: String?) -> TextInputValidation {
            return addressValidator.validate(input: recipient)
        }

        func validateAmount(_ amount: String?) -> InputToDoubleValidation {
            return amountValidator.validate(string: amount)
        }

        func validateGasLimit(_ gasLimit: String?) -> InputToDoubleValidation {
            return amountValidator.validate(string: gasLimit)
        }

        func validateGasPrice(_ gasPrice: String?) -> InputToDoubleValidation {
            return amountValidator.validate(string: gasPrice)
        }
    }
}
