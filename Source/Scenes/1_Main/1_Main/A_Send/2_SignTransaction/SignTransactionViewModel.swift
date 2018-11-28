//
//  SignTransactionViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-17.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

enum SignTransactionUserAction: TrackedUserAction {
    case sign(TransactionResponse)
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

        let activityIndicator = ActivityIndicator()

        bag <~ [
            input.fromView.signAndSendTrigger
                .withLatestFrom(input.fromView.encryptionPassphrase)
                .flatMapLatest {
                    self.transactionUseCase.sendTransaction(for: _payment, wallet: _wallet, encryptionPassphrase: $0)
                        .trackActivity(activityIndicator)
                        .asDriverOnErrorReturnEmpty()
                }
                .do(onNext: { userDid(.sign($0)) })
                .drive()
        ]

        return Output(
            isSignButtonEnabled: input.fromView.encryptionPassphrase.map { $0.count >= WalletEncryptionPassphrase.minimumLenght },
            isSignButtonLoading: activityIndicator.asDriver()
        )
    }

}

extension SignTransactionViewModel {
    struct InputFromView {
        let encryptionPassphrase: Driver<String>
        let signAndSendTrigger: Driver<Void>
    }
    struct Output {
        let isSignButtonEnabled: Driver<Bool>
        let isSignButtonLoading: Driver<Bool>
    }
}
