//
//  Payment.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Payment {
    public let recipient: AddressChecksummed
    public let amount: ZilAmount
    public let gasLimit: GasLimit
    public let gasPrice: GasPrice
    public let nonce: Nonce

    public init(
        to recipient: AddressChecksummedConvertible,
        amount: ZilAmount,
        gasLimit: GasLimit = .defaultGasLimit,
        gasPrice: GasPrice,
        nonce: Nonce = 0
        ) {
        self.recipient = recipient.checksummedAddress
        self.amount = amount
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.nonce = nonce.increasedByOne()
    }
}

public extension Payment {
    static func estimatedTotalTransactionFee(gasPrice: GasPrice, gasLimit: GasLimit = .defaultGasLimit) throws -> Qa {
        return Qa(qa: Qa.Magnitude(gasLimit) * gasPrice.qa)
    }

    static func estimatedTotalCostOfTransaction(amount: ZilAmount, gasPrice: GasPrice, gasLimit: GasLimit = .defaultGasLimit) throws -> ZilAmount {

        let fee = try estimatedTotalTransactionFee(gasPrice: gasPrice, gasLimit: gasLimit)
        let amountInQa = amount.asQa
        let totalInQa: Qa = amountInQa + fee

        let tooLargeError = AmountError.tooLarge(max: ZilAmount.max)

        guard totalInQa < ZilAmount.max.asQa else {
            throw tooLargeError
        }

        // Ugly trick to handle problem of small fees and big amounts.
        // When adding 1E-12 to 21E9 the `Double` rounds down to
        // 21E9 so we lose the 1E-12 part. Thus we subtract 21E9
        // to be able to keep the 1E-12 part and compare it against
        // the transaction cost. Ugly, but it works...
        if totalInQa == ZilAmount.max.asQa {
            let subtractedTotalSupplyFromAmount = totalInQa - ZilAmount.max.asQa
            if (subtractedTotalSupplyFromAmount + fee) != fee {
                throw tooLargeError
            }
        }
        return try ZilAmount(qa: totalInQa)
    }
}
