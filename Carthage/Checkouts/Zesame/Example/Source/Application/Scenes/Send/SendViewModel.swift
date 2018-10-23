//
//  SendViewModel.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zesame

final class SendViewModel {
    private let bag = DisposeBag()
    
    private weak var navigator: SendNavigator?
    private let service: ZilliqaServiceReactive
    private let wallet: Driver<Wallet>

    init(navigator: SendNavigator, wallet: Observable<Wallet>, service: ZilliqaServiceReactive) {
        self.navigator = navigator
        self.service = service
        self.wallet = wallet.asDriverOnErrorReturnEmpty()
    }
}

extension SendViewModel: ViewModelType {

    struct Input {
        let recepientAddress: Driver<String>
        let amountToSend: Driver<String>
        let gasLimit: Driver<String>
        let gasPrice: Driver<String>
        let passphrase: Driver<String>
        let sendTrigger: Driver<Void>
    }

    struct Output {
        let address: Driver<String>
        let nonce: Driver<String>
        let balance: Driver<String>
        let transactionId: Driver<String>
    }

    func transform(input: Input) -> Output {

        let fetchBalanceSubject = BehaviorSubject<Void>(value: ())

        let fetchTrigger = fetchBalanceSubject.asDriverOnErrorReturnEmpty()

        let balanceAndNonce: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet) { _, w in w.address }
            .flatMapLatest {
            self.service
                .getBalance(for: $0)
                .asDriverOnErrorReturnEmpty()
        }

        let walletBalance = Driver.combineLatest(wallet, balanceAndNonce) { WalletBalance(wallet: $0, balanceResponse: $1) }

        let recipient = input.recepientAddress.map { Address(uncheckedString: $0) }.filterNil()
        let amount = input.amountToSend.map { Double($0) }.filterNil()
        let gasLimit = input.gasLimit.map { Double($0) }.filterNil()
        let gasPrice = input.gasPrice.map { Double($0) }.filterNil()

        let payment = Driver.combineLatest(recipient, amount, gasLimit, gasPrice, walletBalance) {
            Payment(to: $0, amount: $1, gasLimit: $2, gasPrice: $3, nonce: $4.nonce)
        }.filterNil()

        let transactionId: Driver<String> = input.sendTrigger
            .withLatestFrom(Driver.combineLatest(payment, walletBalance, input.passphrase) { (payment: $0, keystore: $1.wallet.keystore, encyptedBy: $2) })
            .flatMapLatest {
                self.service.sendTransaction(for: $0.payment, keystore: $0.keystore, passphrase: $0.encyptedBy)
                    .asDriverOnErrorReturnEmpty()
                    // Trigger fetching of balance after successfull send
                    .do(onNext: { _ in
                        fetchBalanceSubject.onNext(())
                    })
        }

        return Output(
            address: wallet.map { $0.address.checksummedHex },
            nonce: walletBalance.map { "\($0.nonce.nonce)" },
            balance: walletBalance.map { "\($0.balance)" },
            transactionId: transactionId
        )
    }
}
