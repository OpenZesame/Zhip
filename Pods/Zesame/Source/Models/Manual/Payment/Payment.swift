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
    public let amount: ZilAmount
    public let gasLimit: GasLimit
    public let gasPrice: GasPrice
    public let nonce: Nonce

    public init(
        to recipient: Address,
        amount: ZilAmount,
        gasLimit: GasLimit = .defaultGasLimit,
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
    static func estimatedTotalTransactionFee(gasPrice: GasPrice, gasLimit: GasLimit = .defaultGasLimit) -> Qa {
        return Qa(magnitude: Qa.Magnitude(gasLimit) * gasPrice.amount.magnitude)
    }

    static func estimatedTotalCostOfTransaction(amount: ZilAmount, gasPrice: GasPrice, gasLimit: GasLimit = .defaultGasLimit) throws -> ZilAmount {

        let fee = estimatedTotalTransactionFee(gasPrice: gasPrice, gasLimit: gasLimit)
        let amountInQa = amount.inQa
        let totalInQaAsMagnitude: Qa.Magnitude = amountInQa.magnitude + fee.magnitude

        let totalSupplyInQaAsMagnitude: Qa.Magnitude = Zil.totalSupply.inQa.magnitude

        let tooLargeError = AmountError.tooLarge(maxMagnitudeIs: Zil.maxMagnitude)

        guard totalInQaAsMagnitude < totalSupplyInQaAsMagnitude else {
            throw tooLargeError
        }

        // Ugly trick to handle problem of small fees and big amounts.
        // When adding 1E-12 to 21E9 the `Double` rounds down to
        // 21E9 so we lose the 1E-12 part. Thus we subtract 21E9
        // to be able to keep the 1E-12 part and compare it against
        // the transaction cost. Ugly, but it works...
        if totalInQaAsMagnitude == totalSupplyInQaAsMagnitude {
            let subtractedTotalSupplyFromAmount = totalInQaAsMagnitude - totalSupplyInQaAsMagnitude
            if (subtractedTotalSupplyFromAmount + fee.magnitude) != fee.magnitude {
                throw tooLargeError
            }
        }

        return try ZilAmount(qa: Qa(totalInQaAsMagnitude))
    }
}
