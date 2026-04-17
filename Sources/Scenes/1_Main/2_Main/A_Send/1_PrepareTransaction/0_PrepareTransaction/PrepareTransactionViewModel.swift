//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Combine
import Foundation
import Zesame

// MARK: - PrepareTransactionUserAction

enum PrepareTransactionUserAction {
    case cancel
    case reviewPayment(Payment)
    case scanQRCode
}

// MARK: - PrepareTransactionViewModel

// swiftlint:disable type_body_length
final class PrepareTransactionViewModel: BaseViewModel<
    PrepareTransactionUserAction,
    PrepareTransactionViewModel.InputFromView,
    PrepareTransactionViewModel.Output
> {
    private let transactionUseCase: TransactionsUseCase
    private let walletUseCase: WalletUseCase
    private let scannedOrDeeplinkedTransaction: Driver<TransactionIntent>

    init(
        walletUseCase: WalletUseCase,
        transactionUseCase: TransactionsUseCase,
        scannedOrDeeplinkedTransaction: Driver<TransactionIntent>
    ) {
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
                .getBalance(for: $0.legacyAddress)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorReturnEmpty()
                .do(onNext: { [unowned self] in
                    transactionUseCase.cacheBalance($0.balance)
                })
        }

        let nonce = latestBalanceAndNonce.map(\.nonce).startWith(0)
        let startingBalance: ZilAmount = transactionUseCase.cachedBalance ?? 0
        let balance: Driver<ZilAmount> = latestBalanceAndNonce.map(\.balance).startWith(startingBalance)

        // MARK: - VALIDATION -> VALUE

        let validator = InputValidator()

        // MARK: Recipient Input ->  Value + Validation

        let recipientValidationValue: Driver<Validation<Address, AddressValidator.Error>> = Driver.merge(
            input.fromView.recipientAddress.map { validator.validateRecipient($0) },
            scannedOrDeeplinkedTransaction.map { .valid($0.to) }
        )

        let recipient: Driver<Address?> = recipientValidationValue.map(\.value).eraseToAnyPublisher()

        let recipientValidationTrigger = input.fromView.didEndEditingRecipientAddress

        let recipientValidation: Driver<AnyValidation> = Driver.merge(
            recipientValidationTrigger.withLatestFrom(recipientValidationValue).onlyErrors(),
            recipientValidationValue.nonErrors()
        )

        // MARK: GasLimit + GasPrice Input -> Value + Validation

        let _startingGasLimit = GasLimit.minimum
        let gasLimitValidationValue = input.fromView.gasLimit.map { validator.validateGasLimit($0) }
            .startWith(.valid(_startingGasLimit))
        let gasLimit: Driver<GasLimit?> = gasLimitValidationValue.map(\.value).eraseToAnyPublisher()

        let _startingGasPrice: GasPrice = .min
        let gasPriceValidationValue = input.fromView.gasPrice.map { validator.validateGasPrice($0) }
            .startWith(.valid(_startingGasPrice))

        let gasPrice: Driver<GasPrice?> = gasPriceValidationValue.map(\.value).eraseToAnyPublisher()

        let maxAmountTrigger = input.fromView.maxAmountTrigger

        let gasLimitValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingGasLimit,
            maxAmountTrigger
        )

        let gasLimitValidation = Driver.merge(
            gasLimitValidationErrorTrigger.withLatestFrom(gasLimitValidationValue).onlyErrors(),
            gasLimitValidationValue.nonErrors()
        )

        let gasPriceValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingGasPrice,
            maxAmountTrigger
        )

        let gasPriceValidation = Driver.merge(
            gasPriceValidationErrorTrigger.withLatestFrom(gasPriceValidationValue).onlyErrors(),
            gasPriceValidationValue.nonErrors()
        )

        let zilAmountFromScannedOrDeeplinkedTransaction: Driver<AmountValidator<ZilAmount>.ValidationResult> =
            scannedOrDeeplinkedTransaction.map(\.amount).filterNil().map { .valid(.amount(
                $0,
                in: .zil
            )) }.eraseToAnyPublisher()

        // MARK: Amount + MaxAmountTrigger Input -> Value + Validation

        let amountWithoutSufficientFundsCheckValidationValue: Driver<AmountValidator<ZilAmount>.ValidationResult> =
            Driver.merge(
                input.fromView.amountToSend.map { validator.validateAmount($0) },
                zilAmountFromScannedOrDeeplinkedTransaction
            )

        let amountWithoutSufficientFundsCheck: Driver<ZilAmount?> = amountWithoutSufficientFundsCheckValidationValue
            .map { $0.value?.amount }.eraseToAnyPublisher()

        let amountValidationValue: Driver<SufficientFundsValidator.ValidationResult> = combineLatest(
            Driver.merge(
                // Input from fields or deeplinked/scanned
                amountWithoutSufficientFundsCheck,

                // Max trigger -> Balance SUBTRACT GasPrice (default to min)
                maxAmountTrigger.withLatestFrom(
                    combineLatest(
                        balance.startWith(startingBalance),
                        gasLimit.startWith(_startingGasLimit),
                        gasPrice.startWith(_startingGasPrice),
                        resultSelector: { (
                            latestBalance: ZilAmount?,
                            latestGasLimit: GasLimit?,
                            latestGasPrice: GasPrice?
                        ) -> ZilAmount? in
                            let balanceOrZero: ZilAmount = latestBalance ?? startingBalance
                            let gasLimitOrMin: GasLimit = latestGasLimit ?? _startingGasLimit
                            let gasPriceOrMin: GasPrice = latestGasPrice ?? _startingGasPrice

                            guard let balanceMinusGas: ZilAmount = try? balanceOrZero - Payment
                                .estimatedTotalTransactionFee(
                                    gasPrice: gasPriceOrMin,
                                    gasLimit: gasLimitOrMin
                                )
                            else {
                                return nil
                            }
                            return balanceMinusGas
                        }
                    )
                ) { $1 }
            ),

            gasLimit.startWith(_startingGasLimit),
            gasPrice.startWith(_startingGasPrice),
            balance.startWith(startingBalance),
            resultSelector: { (amount: ZilAmount?, gasLimit: GasLimit?, gasPrice: GasPrice?, balance: ZilAmount?) in
                validator.validate(amount: amount, gasLimit: gasLimit, gasPrice: gasPrice, lessThanBalance: balance)
            }
        )

        let amountBoundByBalance: Driver<ZilAmount?> = amountValidationValue.map(\.value).eraseToAnyPublisher()

        let amountValidationErrorTrigger: Driver<Void> = Driver.merge(
            input.fromView.didEndEditingAmount,
            scannedOrDeeplinkedTransaction.mapToVoid(),
            gasPriceValidationValue.mapToVoid()
        )

        let amountValidation: Driver<AnyValidation> = Driver.merge(
            amountValidationErrorTrigger.withLatestFrom(amountValidationValue)
                .map { AnyValidation($0) }.eraseToAnyPublisher(),
            amountValidationValue.nonErrors()
        )

        let payment: Driver<Payment?> = combineLatest(
            recipient,
            amountBoundByBalance,
            gasLimit,
            gasPrice,
            nonce,
            resultSelector: { r, a, gl, gp, n -> Payment? in
                guard let to = try? r?.toChecksummedLegacyAddress(), let amount = a, let gasLimit = gl,
                      let gasPrice = gp
                else {
                    return nil
                }
                do {
                    return try Payment(to: to, amount: amount, gasLimit: gasLimit, gasPrice: gasPrice, nonce: n)
                } catch {
                    print(error)
                    return nil
                }
            }
        )

        // Setup navigation
        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .cancel) })
                .drive(),

            input.fromView.scanQRTrigger
                .do(onNext: { userIntends(to: .scanQRCode) })
                .drive(),

            input.fromView.toReviewTrigger.withLatestFrom(payment.filterNil())
                .do(onNext: { userIntends(to: .reviewPayment($0)) })
                .drive(),
        ]

        // MARK: FORMATTING

        let formatter = AmountFormatter()
        let balanceFormatted: Driver<String> = balance.map { formatter.format(
            amount: $0,
            in: .zil,
            formatThousands: true,
            showUnit: true
        ) }.eraseToAnyPublisher()

        // It is deliberate that we do NOT auto checksum the address here. We would like to be able to inform the user
        // that
        // she might have pasted an unchecksummed address.
        let recipientFormatted: Driver<String> = recipient.filterNil().map(\.asString).eraseToAnyPublisher()

        let amountFormatted: Driver<String?> = amountBoundByBalance.filterNil()
            .map { formatter.format(amount: $0, in: .zil, formatThousands: false) }
            .eraseToAnyPublisher()
            .ifEmpty(switchTo: amountWithoutSufficientFundsCheckValidationValue.map {
                guard let value = $0.value else { return nil }
                switch value {
                case let .string(string): return string
                case let .amount(amount, _):
                    return formatter.format(amount: amount, in: .zil, formatThousands: false)
                }
            }.eraseToAnyPublisher())

        let isReviewButtonEnabled: Driver<Bool> = payment.map { $0 != nil }.eraseToAnyPublisher()

        let gasLimitPlaceholder: Driver<String> = Driver.just(GasLimit.minimum).map {
            String(localized: .PrepareTransaction.gasLimitField(minimum: $0.description))
        }.eraseToAnyPublisher()

        let gasPricePlaceholder: Driver<String> = Driver.just(GasPrice.min).map {
            String(localized: .PrepareTransaction.gasPriceField(
                minQa: formatter.format(amount: $0, in: .li, formatThousands: true, showUnit: false),
                minZil: formatter.format(amount: $0, in: .zil, formatThousands: true, showUnit: true)
            ))
        }.eraseToAnyPublisher()

        let gasLimitFormatted: Driver<String> = gasLimit.filterNil().map(\.description).eraseToAnyPublisher()
        let gasPriceFormatted: Driver<String> = gasPrice.filterNil()
            .map { formatter.format(amount: $0, in: .li, formatThousands: true) }
            .eraseToAnyPublisher()

        let balanceWasUpdatedAt: Driver<Date?> = fetchTrigger.map { [unowned self] in
            transactionUseCase.balanceUpdatedAt
        }.eraseToAnyPublisher()

        let refreshControlLastUpdatedTitle: Driver<String> = balanceWasUpdatedAt.map {
            BalanceLastUpdatedFormatter().string(from: $0)
        }.eraseToAnyPublisher()

        let setAmountInViewTrigger = Driver.merge(
            input.fromView.maxAmountTrigger,
            scannedOrDeeplinkedTransaction.mapToVoid()
        )

        let setAmountInViewOnlyByExternalTrigger = setAmountInViewTrigger.withLatestFrom(amountFormatted)

        return Output(
            refreshControlLastUpdatedTitle: refreshControlLastUpdatedTitle,
            isFetchingBalance: activityIndicator.asDriver(),
            isReviewButtonEnabled: isReviewButtonEnabled,
            balance: balanceFormatted,

            recipient: recipientFormatted,
            recipientAddressValidation: recipientValidation,

            amountPlaceholder: Driver
                .just(String(localized: .PrepareTransaction.amountField(unit: Unit.zil.displayName))),
            amount: setAmountInViewOnlyByExternalTrigger,
            amountValidation: amountValidation,

            gasLimitMeasuredInLi: gasLimitFormatted,
            gasLimitPlaceholder: gasLimitPlaceholder,
            gasLimitValidation: gasLimitValidation,

            gasPriceMeasuredInLi: gasPriceFormatted,
            gasPricePlaceholder: gasPricePlaceholder,
            gasPriceValidation: gasPriceValidation,

            costOfTransaction: combineLatest(gasLimit, gasPrice).flatMapLatest {
                (gl: GasLimit?, gp: GasPrice?) -> Driver<String?> in
                guard let gasLimit = gl else {
                    return Driver<String?>.just(nil)
                }
                guard let gasPrice = gp else {
                    return Driver<String?>.just(nil)
                }
                return
                    Just((gasPrice, gasLimit)).eraseToAnyPublisher()
                        .compactMap { try? Payment.estimatedTotalTransactionFee(gasPrice: $0, gasLimit: $1) }
                        .map { formatter.format(amount: $0, in: .zil, formatThousands: true, showUnit: true) }
                        .map { String(localized: .PrepareTransaction.transactionFeeLabel(fee: $0)) }
                        .eraseToAnyPublisher()
            }
        )
    }
}

extension PrepareTransactionViewModel {
    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let scanQRTrigger: Driver<Void>
        let maxAmountTrigger: Driver<Void>
        let toReviewTrigger: Driver<Void>

        let recipientAddress: Driver<String>
        let didEndEditingRecipientAddress: Driver<Void>

        let amountToSend: Driver<String>
        let didEndEditingAmount: Driver<Void>

        let gasLimit: Driver<String>
        let didEndEditingGasLimit: Driver<Void>

        let gasPrice: Driver<String>
        let didEndEditingGasPrice: Driver<Void>
    }

    struct Output {
        let refreshControlLastUpdatedTitle: Driver<String>
        let isFetchingBalance: Driver<Bool>
        let isReviewButtonEnabled: Driver<Bool>
        let balance: Driver<String>

        let recipient: Driver<String>
        let recipientAddressValidation: Driver<AnyValidation>

        let amountPlaceholder: Driver<String>
        let amount: Driver<String?>
        let amountValidation: Driver<AnyValidation>

        let gasLimitMeasuredInLi: Driver<String>
        let gasLimitPlaceholder: Driver<String>
        let gasLimitValidation: Driver<AnyValidation>

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
        private let zilAmountValidator = AmountValidator<ZilAmount>()
        private let gasPriceValidator = GasPriceValidator()
        private let gasLimitValidator = GasLimitValidator()
        private let sufficientFundsValidator = SufficientFundsValidator()

        func validateRecipient(_ recipient: String?) -> AddressValidator.ValidationResult {
            addressValidator.validate(input: recipient)
        }

        func validate(
            amount: ZilAmount?,
            gasLimit: GasLimit?,
            gasPrice: GasPrice?,
            lessThanBalance balance: ZilAmount?
        ) -> SufficientFundsValidator.ValidationResult {
            sufficientFundsValidator.validate(input: (amount, gasLimit, gasPrice, balance))
        }

        func validateAmount(_ amount: String) -> AmountValidator<ZilAmount>.ValidationResult {
            zilAmountValidator.validate(input: (amount, Zesame.Unit.zil))
        }

        func validateGasLimit(_ gasLimit: String?) -> GasLimitValidator.ValidationResult {
            gasLimitValidator.validate(input: gasLimit)
        }

        func validateGasPrice(_ gasPrice: String?) -> GasPriceValidator.ValidationResult {
            gasPriceValidator.validate(input: gasPrice)
        }
    }
}

// swiftlint:enable type_body_length
