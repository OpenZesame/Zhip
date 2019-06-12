// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

public struct Payment {
    public let recipient: LegacyAddress
    public let amount: ZilAmount
    public let gasLimit: GasLimit
    public let gasPrice: GasPrice
    public let nonce: Nonce

    public init(
        to recipient: LegacyAddress,
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
