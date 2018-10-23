//
//  TransactionsUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame
import RxSwift

final class DefaultTransactionsUseCase {
    private let zilliqaService: ZilliqaServiceReactive

    init(zilliqaService: ZilliqaServiceReactive) {
        self.zilliqaService = zilliqaService
    }
}

extension DefaultTransactionsUseCase: TransactionsUseCase {

    func getBalance(for address: Address) -> Observable<BalanceResponse> {
        return zilliqaService.getBalance(for: address)
    }

    func sendTransaction(for payment: Payment, wallet: Wallet, encryptionPassphrase: String) -> Observable<TransactionIdentifier> {
        return zilliqaService.sendTransaction(for: payment, keystore: wallet.keystore, passphrase: encryptionPassphrase)
    }
}
