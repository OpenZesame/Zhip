//
//  UnsignedTransaction.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-07.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct UnsignedTransaction: Encodable {
    let version: Int
    let nonce: Int
    let to: String
    let amount: Double
    let gasPrice: Double
    let gasLimit: Double
    let data: String
    let code: String

    init(payment: Payment, version: Int = 0, data: String = "", code: String = "") {
        self.to = payment.recipient.checksummedHex
        self.amount = payment.amount
        self.gasPrice = payment.gasPrice
        self.gasLimit = payment.gasLimit
        self.nonce = payment.nonce
        self.version = version
        self.data = data
        self.code = code
    }
}
