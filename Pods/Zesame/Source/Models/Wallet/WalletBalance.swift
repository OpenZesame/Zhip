//
//  WalletBalance.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct WalletBalance {
    public let wallet: Wallet
    public let balance: Amount
    public let nonce: Nonce

    public init(wallet: Wallet, balance: Amount = 0, nonce: Nonce = 0) {
        self.wallet = wallet
        self.balance = balance
        self.nonce = nonce
    }
}

public extension WalletBalance {
    init(wallet: Wallet, balanceResponse: BalanceResponse) {
        self.init(wallet: wallet, balance: balanceResponse.balance, nonce: balanceResponse.nonce)
    }
}
