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
    public let amount: Amount
    public let gasLimit: Amount
    public let gasPrice: GasPrice
    public let nonce: Nonce

    public init(
        to recipient: Address,
        amount: Amount,
        gasLimit: Amount,
        gasPrice: GasPrice,
        nonce: Nonce = 0
        ) {
        self.recipient = recipient
        self.amount = amount
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.nonce = nonce.increasedByOne()
    }
}

public extension Payment {
    static func estimatedTotalTransactionFee(gasPrice: GasPrice, gasLimit: Amount = 1) throws -> Amount {
        let cost = try GasPrice(significand: gasPrice.significand * gasLimit.significand)
        return cost.asAmount()
    }

    static func estimatedTotalCostOfTransaction(amount: Amount, gasPrice: GasPrice, gasLimit: Amount = 1) throws -> Amount {
        let fee = try estimatedTotalTransactionFee(gasPrice: gasPrice, gasLimit: gasLimit).significand
        let total = amount.significand + fee

        // Ugly trick to handle problem of small fees and big amounts.
        // When adding 1E-12 to 21E9 the `Double` rounds down to
        // 21E9 so we lose the 1E-12 part. Thus we subtract 21E9
        // to be able to keep the 1E-12 part and compare it against
        // the transaction cost. Ugly, but it works...
        let feeIsInteger = Double(Int(fee)) == fee
        if !feeIsInteger, total == Amount.maxSignificand {
            let subtractedTotalSupplyFromAmount = amount.significand - Amount.maxSignificand
            if (subtractedTotalSupplyFromAmount + fee) != fee {
                throw AmountError.tooLarge(max: Amount.maxSignificand)
            }
        }

        return try Amount(significand: total)
    }
}
