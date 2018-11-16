//
//  SendViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

// MARK: - SendNavigation
enum SendNavigation: TrackedUserAction {
    case userInitiatedTransaction
    case userSelectedSeeTransactionDetailsInBrowser(transactionId: String)
}

// MARK: - SendViewModel
final class SendViewModel: BaseViewModel<
    SendNavigation,
    SendViewModel.InputFromView,
    SendViewModel.Output
> {
    private let transactionUseCase: TransactionsUseCase
    private let walletUseCase: WalletUseCase
    private let deepLinkedTransaction: Driver<Transaction>

    init(walletUseCase: WalletUseCase, transactionUseCase: TransactionsUseCase, deepLinkedTransaction: Observable<Transaction>) {
        self.walletUseCase = walletUseCase
        self.transactionUseCase = transactionUseCase
        self.deepLinkedTransaction = deepLinkedTransaction.asDriverOnErrorReturnEmpty()
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
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

        let transactionIdSubject = BehaviorSubject<String?>(value: nil)

        let transactionId = transactionIdSubject.asDriverOnErrorReturnEmpty()

        bag <~ [fromView.sendTrigger
            .withLatestFrom(Driver.combineLatest(payment.filterNil(), wallet, fromView.encryptionPassphrase) { (payment: $0, wallet: $1, passphrase: $2) })
            .flatMapLatest {
                self.transactionUseCase.sendTransaction(for: $0.payment, wallet: $0.wallet, encryptionPassphrase: $0.passphrase)
                    .asDriverOnErrorReturnEmpty()
                    // Trigger fetching of balance after successfull send
                    .do(onNext: { [unowned self] _ in
                        transactionIdSubject.onNext(nil)
                        self.stepper.step(.userInitiatedTransaction)
                        // TODO: poll API using transaction ID later on
                        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                            fetchBalanceSubject.onNext(())
                        }
                    })
            }
            .do(onNext: { transactionIdSubject.onNext($0.transactionIdentifier) })
            .drive(),

                fromView.openTransactionDetailsInBrowserTrigger.withLatestFrom(transactionId.filterNil())
                    .do(onNext: { [unowned stepper] in
                        stepper.step(.userSelectedSeeTransactionDetailsInBrowser(transactionId: $0))
                    })
                    .drive()
        ]

        let isEncryptionPassphraseCorrect: Driver<Bool> = Driver.combineLatest(fromView.encryptionPassphrase, wallet) { (passphrase: $0, wallet: $1) }
            .flatMapLatest {
                self.walletUseCase.verify(passhrase: $0.passphrase, forWallet: $0.wallet).asDriverOnErrorReturnEmpty()
        }

        let isSendButtonEnabled: Driver<Bool> = Driver.combineLatest(payment.map { $0 != nil }, isEncryptionPassphraseCorrect) { $0 && $1 }

        let isRecipientAddressValid = Driver.merge(recipientFromField.map { $0 != nil }, recipientFromDeepLinkedTransaction.map { _ in true })

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            isSendButtonEnabled: isSendButtonEnabled,
            balance: balance.map { €.Label.balance($0.balance.amount.description) },
            nonce: balance.map { $0.nonce.nonce.description },
            amount: amountFromDeepLinkedTransaction.map { $0.description },
            recipient: recipient.map { $0.checksummedHex },
            isRecipientAddressValid: isRecipientAddressValid,
            transactionId: transactionId.map { $0 ?? "No tx id" },
            isTxInfoButtonEnabled: transactionId.map { $0 != nil }
        )
    }
}

private typealias € = L10n.Scene.Send

extension SendViewModel {

    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let recepientAddress: Driver<String>
        let amountToSend: Driver<String>
        let gasLimit: Driver<String>
        let gasPrice: Driver<String>
        let encryptionPassphrase: Driver<String>
        let openTransactionDetailsInBrowserTrigger: Driver<Void>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let isSendButtonEnabled: Driver<Bool>
        let balance: Driver<String>
        let nonce: Driver<String>
        let amount: Driver<String>
        let recipient: Driver<String>
        let isRecipientAddressValid: Driver<Bool>
        let transactionId: Driver<String>
        let isTxInfoButtonEnabled: Driver<Bool>
    }
}
