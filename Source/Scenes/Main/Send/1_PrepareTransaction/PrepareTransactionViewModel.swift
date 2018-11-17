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
        func userIntends(to intention: Step) {
            stepper.step(intention)
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

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .cancel) })
                .drive()
        ]

        let isRecipientAddressValid = Driver.merge(recipientFromField.map { $0 != nil }, recipientFromDeepLinkedTransaction.map { _ in true })

        let isSendButtonEnabled = payment.map { $0 != nil }

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balance.map { €.Label.balance($0.balance.amount.description) },
            amount: amountFromDeepLinkedTransaction.map { $0.description },
            recipient: recipient.map { $0.checksummedHex },
            isRecipientAddressValid: isRecipientAddressValid
        )
    }
}

extension PrepareTransactionViewModel {

    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let recepientAddress: Driver<String>
        let amountToSend: Driver<String>
        let gasLimit: Driver<String>
        let gasPrice: Driver<String>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let isSendButtonEnabled: Driver<Bool>
        let balance: Driver<String>
        let amount: Driver<String>
        let recipient: Driver<String>
        let isRecipientAddressValid: Driver<Bool>
    }
}
