//
//  ChooseWalletUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import Zesame

protocol UseCaseProvider {
    func makeChooseWalletUseCase() -> ChooseWalletUseCase
    func makeTransactionsUseCase() -> TransactionsUseCase
}

protocol ChooseWalletUseCase {
    func createNewWallet() -> Observable<Wallet>
    func restoreWallet(from restoration: KeyRestoration) -> Observable<Wallet>
}

protocol TransactionsUseCase {

    func getBalance(for address: Address) -> Observable<BalanceResponse>

    func sendTransaction(for payment: Payment, signWith: KeyPair) -> Observable<TransactionIdentifier>

}
