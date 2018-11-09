//
//  Payment.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Payment {
    public let recipient: Address
    public let amount: Double
    public let gasLimit: Double
    public let gasPrice: Double
    public let nonce: Int

    public init?(
        to recipient: Address,
        amount: Double,
        gasLimit: Double = 10,
        gasPrice: Double = 1,
        nonce: Nonce = 0
        ) {
        guard
            amount > 0,
            gasLimit > 0,
            gasPrice > 0
        else { return nil }
        self.recipient = recipient
        self.amount = amount
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.nonce = nonce.nonce + 1
    }
}
