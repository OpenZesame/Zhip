//
//  TransactionsUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import Zesame

protocol TransactionsUseCase {

    /// Checks if the passed `passphrase` was used to encypt the Keystore
    func verify(passhrase: String, forKeystore keystore: Keystore) -> Observable<Bool>
    func getBalance(for address: Address) -> Observable<BalanceResponse>
    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassphrase: String) -> Observable<TransactionResponse>
}

extension TransactionsUseCase {

    /// Checks if the passed `passphrase` was used to encypt the Keystore inside the Wallet
    func verify(passhrase: String, forWallet wallet: Wallet) -> Observable<Bool> {
        return verify(passhrase: passhrase, forKeystore: wallet.keystore)
    }
}
