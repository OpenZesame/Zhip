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

final class SendViewModel {
    private let bag = DisposeBag()
    
    private weak var navigator: SendNavigator?
    private let useCase: TransactionsUseCase
    private let wallet: Wallet

    init(navigator: SendNavigator, wallet: Wallet, useCase: TransactionsUseCase) {
        self.navigator = navigator
        self.useCase = useCase
        self.wallet = wallet
    }
}

extension SendViewModel: ViewModelType {

    struct Input {
        let sendTrigger: Driver<Void>
        let recepientAddress: Driver<String>
        let amountToSend: Driver<String>
        let gasLimit: Driver<String>
        let gasPrice: Driver<String>
    }

    struct Output {
        let wallet: Driver<Wallet>
        let transactionId: Driver<String>
    }

    func transform(input: Input) -> Output {

        let _address = self.wallet.address

        let fetchBalanceSubject = BehaviorSubject<Void>(value: ())

        let fetchTrigger = fetchBalanceSubject.asDriverOnErrorReturnEmpty()

        let balanceAndNonce: Driver<BalanceResponse> = fetchTrigger.flatMapLatest { _ in 
            self.useCase
                .getBalance(for: _address)
                .asDriverOnErrorReturnEmpty()
        }

        let _keyPair = self.wallet.keyPair
        let wallet: Driver<Wallet> = balanceAndNonce.map { balance in
            let amount = try! Amount(double: Double(balance.balance)!)
            return Wallet(keyPair: _keyPair, balance: amount, nonce: Nonce(balance.nonce))
        }

        let recipient = input.recepientAddress.map { Recipient(string: $0) }.filterNil()
        let amount = input.amountToSend.map { Double($0) }.filterNil()
        let gasLimit = input.gasLimit.map { Double($0) }.filterNil()
        let gasPrice = input.gasPrice.map { Double($0) }.filterNil()

        let payment = Driver.combineLatest(recipient, amount, gasLimit, gasPrice, wallet) {
            Payment(to: $0, amount: $1, gasLimit: $2, gasPrice: $3, from: $4)
        }.filterNil()

        let transactionId: Driver<String> = input.sendTrigger
            .withLatestFrom(Driver.combineLatest(payment, wallet) { (payment: $0, keyPair: $1.keyPair) })
            .flatMapLatest {
                self.useCase.sendTransaction(for: $0.payment, signWith: $0.keyPair)
                    .asDriverOnErrorReturnEmpty()
                    // Trigger fetching of balance after successfull send
                    .do(onNext: { _ in
                        fetchBalanceSubject.onNext(())
                    })
        }

        return Output(
            wallet: wallet,
            transactionId: transactionId
        )
    }
}
