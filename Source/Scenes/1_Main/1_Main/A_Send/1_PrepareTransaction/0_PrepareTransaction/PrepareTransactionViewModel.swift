// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

// MARK: - PrepareTransactionUserAction
enum PrepareTransactionUserAction {
	case cancel
	case signPayment(Payment)
	case scanQRCode
}

// MARK: - PrepareTransactionViewModel
private typealias € = L10n.Scene.PrepareTransaction
// swiftlint:disable:next type_body_length
final class PrepareTransactionViewModel: BaseViewModel<
	PrepareTransactionUserAction,
	PrepareTransactionViewModel.InputFromView,
	PrepareTransactionViewModel.Output
> {
	private let transactionUseCase: TransactionsUseCase
	private let walletUseCase: WalletUseCase
	private let scannedOrDeeplinkedTransaction: Driver<TransactionIntent>

	init(walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase, scannedOrDeeplinkedTransaction: Driver<TransactionIntent>) {
		self.walletUseCase = walletUseCase
		self.transactionUseCase = transactionUseCase
		self.scannedOrDeeplinkedTransaction = scannedOrDeeplinkedTransaction
	}

	// swiftlint:disable:next function_body_length
	override func transform(input: Input) -> Output {
		func userIntends(to intention: NavigationStep) {
			navigator.next(intention)
		}

		let wallet = walletUseCase.wallet.filterNil().asDriverOnErrorReturnEmpty()
		let activityIndicator = ActivityIndicator()
		let errorTracker = ErrorTracker()

		let fetchTrigger = Driver.merge(
			input.fromView.pullToRefreshTrigger,
			wallet.mapToVoid()
		)

		// Fetch latest balance from API
		let latestBalanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest {
			self.transactionUseCase
				.getBalance(for: $0.address)
				.trackActivity(activityIndicator)
				.trackError(errorTracker)
				.asDriverOnErrorReturnEmpty()
                .do(onNext: { [unowned self] in
                    self.transactionUseCase.cacheBalance($0.balance)
                })
		}

		let nonce = latestBalanceAndNonce.map { $0.nonce }.startWith(0)
		let _startingBalance: ZilAmount = transactionUseCase.cachedBalance ?? 0
		let balance: Driver<ZilAmount> = latestBalanceAndNonce.map { $0.balance }.startWith(_startingBalance)

		// MARK: - VALIDATION -> VALUE
		let validator = InputValidator()

		// MARK: Recipient Input ->  Value + Validation
        let recipientValidationValue: Driver<Validation<Address, AddressValidator.Error>> = Driver.merge(
			input.fromView.recepientAddress.map { validator.validateRecipient($0) },
			scannedOrDeeplinkedTransaction.map { .valid(Address.checksummed($0.to)) }
		)

		let recipient: Driver<Address?> = recipientValidationValue.map { $0.value }

        let recipientValidationTrigger = input.fromView.didEndEditingRecipientAddress

		let recipientValidation: Driver<AnyValidation> = Driver.merge(
            recipientValidationTrigger.withLatestFrom(recipientValidationValue).onlyErrors(),
			recipientValidationValue.nonErrors()
		)

		// MARK: GasPrice Input -> Value + Validation
        let _startingGasPrice: GasPrice = .min
        let gasPriceValidationValue = input.fromView.gasPrice.map { validator.validateGasPrice($0) }.startWith(.valid(_startingGasPrice))

        let gasPrice = gasPriceValidationValue.map { $0.value }

        let maxAmountTrigger = input.fromView.maxAmountTrigger

        let gasPriceValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingGasPrice,
            maxAmountTrigger
        )

		let gasPriceValidation = Driver.merge(
            gasPriceValidationErrorTrigger.withLatestFrom(gasPriceValidationValue).onlyErrors(),
			gasPriceValidationValue.nonErrors()
        )

		// MARK: Amount + MaxAmountTrigger Input -> Value + Validation
		let amountWithoutSufficientFundsCheckValidationValue = Driver.merge(
			input.fromView.amountToSend.map { validator.validateAmount($0) },
            scannedOrDeeplinkedTransaction.map { $0.amount }.filterNil().map { .valid($0) }
		)

		let amountWithoutSufficientFundsCheck: Driver<ZilAmount?> = amountWithoutSufficientFundsCheckValidationValue.map { $0.value }

        let amountValidationValue: Driver<SufficientFundsValidator.ValidationResult> = Driver.combineLatest(

            Driver.merge(
                // Input from fields or deeplinked/scanned
                amountWithoutSufficientFundsCheck,

                // Max trigger -> Balance SUBTRACT GasPrice (default to min)
                maxAmountTrigger.withLatestFrom(
                    Driver.combineLatest(
                        balance.startWith(_startingBalance),
                        gasPrice.startWith(_startingGasPrice)
                    ) { (latestBalance: ZilAmount?, latestGasPrice: GasPrice?) -> ZilAmount? in
                        let balanceOrZero: ZilAmount = latestBalance ?? _startingBalance
                        let gasPriceOrMin: GasPrice = latestGasPrice ?? _startingGasPrice

                        guard let balanceMinusGas: ZilAmount = try? balanceOrZero - gasPriceOrMin else {
                            return nil
                        }
                        return balanceMinusGas
                    }
                ) { $1 }
            ),

            gasPrice.startWith(_startingGasPrice),
            balance.startWith(_startingBalance)
        ) { (amount: ZilAmount?, gasPrice: GasPrice?, balance: ZilAmount?) in
            validator.validate(amount: amount, gasPrice: gasPrice, lessThanBalance: balance)
        }

		let amountBoundByBalance = amountValidationValue.map { $0.value }

		let amountValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingAmount,
			scannedOrDeeplinkedTransaction.mapToVoid()
		)

		let amountValidation = Driver.merge(
            amountValidationErrorTrigger.withLatestFrom(gasPriceValidationValue).onlyErrors(),
			amountValidationValue.nonErrors()
		)

		let payment: Driver<Payment?> = Driver.combineLatest(recipient, amountBoundByBalance, gasPrice, nonce) {
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

		// MARK: FORMATTING
		let formatter = AmountFormatter()
        let balanceFormatted = balance.map { formatter.format(amount: $0, in: .zil, showUnit: true) }

        // It is deliberate that we do NOT auto checksum the address here. We would like to be able to inform the user that
        // she might have pasted an unchecksummed address.
		let recipientFormatted = recipient.filterNil().map { $0.hexString.value }

        let amountFormatted = amountBoundByBalance.filterNil().map { formatter.format(amount: $0, in: .zil) }

		let isSendButtonEnabled = payment.map { $0 != nil }

        let gasPricePlaceholder = Driver.just(GasPrice.min).map { €.Field.gasPrice(formatter.format(amount: $0, in: .li, showUnit: true)) }

        let gasPriceFormatted = gasPrice.filterNil().map { formatter.format(amount: $0, in: .li) }

        let balanceWasUpdatedAt = fetchTrigger.map { [unowned self] in
            self.transactionUseCase.balanceUpdatedAt
        }

        let refreshControlLastUpdatedTitle: Driver<String> = balanceWasUpdatedAt.map {
            BalanceLastUpdatedFormatter().string(from: $0)
        }

        return Output(
            refreshControlLastUpdatedTitle: refreshControlLastUpdatedTitle,
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balanceFormatted,

            recipient: recipientFormatted,
            recipientAddressValidation: recipientValidation,

            amount: amountFormatted.map { $0 == "0" ? "" : $0 },
            amountValidation: amountValidation,

            gasPriceMeasuredInLi: gasPriceFormatted,
            gasPricePlaceholder: gasPricePlaceholder,
            gasPriceValidation: gasPriceValidation,

            costOfTransaction: gasPrice.flatMapLatest {
                guard let gasPrice = $0 else {
                    return Driver<String?>.just(nil)
                }
                return Observable<GasPrice>.just(gasPrice)
                    .map { try Payment.estimatedTotalTransactionFee(gasPrice: $0) }
                    .asDriverOnErrorReturnEmpty()
                    .map { formatter.format(amount: $0, in: .zil, showUnit: true) }
                    .map { €.Label.costOfTransactionInZil($0) }
            }
        )
	}
}

extension PrepareTransactionViewModel {

	struct InputFromView {
		let pullToRefreshTrigger: Driver<Void>
		let scanQRTrigger: Driver<Void>
		let maxAmountTrigger: Driver<Void>
		let sendTrigger: Driver<Void>

		let recepientAddress: Driver<String>
		let didEndEditingRecipientAddress: Driver<Void>

		let amountToSend: Driver<String>
		let didEndEditingAmount: Driver<Void>

		let gasPrice: Driver<String>
		let didEndEditingGasPrice: Driver<Void>
	}

	struct Output {
        let refreshControlLastUpdatedTitle: Driver<String>
		let isFetchingBalance: Driver<Bool>
		let isSendButtonEnabled: Driver<Bool>
		let balance: Driver<String>

		let recipient: Driver<String>
		let recipientAddressValidation: Driver<AnyValidation>

		let amount: Driver<String>
		let amountValidation: Driver<AnyValidation>

		let gasPriceMeasuredInLi: Driver<String>
		let gasPricePlaceholder: Driver<String>
		let gasPriceValidation: Driver<AnyValidation>

        let costOfTransaction: Driver<String?>
	}
}

// MARK: - Field Validation
extension PrepareTransactionViewModel {
	struct InputValidator {
		private let addressValidator = AddressValidator()
		private let amountValidator = AmountValidator()
		private let gasPriceValidator = GasPriceValidator()
		private let sufficientFundsValidator = SufficientFundsValidator()

		func validateRecipient(_ recipient: String?) -> AddressValidator.ValidationResult {
			return addressValidator.validate(input: recipient)
		}

		func validate(amount: ZilAmount?, gasPrice: GasPrice?, lessThanBalance balance: ZilAmount?) -> SufficientFundsValidator.ValidationResult {
			return sufficientFundsValidator.validate(input: (amount, gasPrice, balance))
		}

		func validateAmount(_ amount: String) -> AmountValidator.ValidationResult {
			return amountValidator.validate(input: amount)
		}

		func validateGasPrice(_ gasPrice: String?) -> GasPriceValidator.ValidationResult {
			return gasPriceValidator.validate(input: gasPrice)
		}
	}
}
