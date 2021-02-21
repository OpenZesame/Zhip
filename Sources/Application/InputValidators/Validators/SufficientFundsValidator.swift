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

import Zesame

import Validator

private typealias € = L10n.Error.Input.Amount

struct SufficientFundsValidator: InputValidator {
    enum Error: Swift.Error {
        case insufficientFunds
        case amountError(AmountError<ZilAmount>)
    }

    // swiftlint:disable:next large_tuple
    func validate(input: (amount: ZilAmount?, gasPrice: GasPrice?, balance: ZilAmount?)) -> Validation<ZilAmount, Error> {
		guard let amount = input.amount, let gasPrice = input.gasPrice, let balance = input.balance else {
			return .invalid(.empty)
		}

        do {
            let totalCost = try Payment.estimatedTotalCostOfTransaction(amount: amount, gasPrice: gasPrice)
            guard totalCost <= balance else {
                return self.error(Error.insufficientFunds)
            }
        } catch let error as AmountError<ZilAmount> {
            return self.error(Error.amountError(error))
        } catch let otherError {
            let zilAmountError: AmountError<ZilAmount> = .init(error: otherError)
            return self.error(Error.amountError(zilAmountError))
        }

        return .valid(amount)
    }
}

extension SufficientFundsValidator.Error: InputError {
    var errorMessage: String {
        switch self {
        case .insufficientFunds: return €.exceedingBalance
        case .amountError(let amountError): return amountError.errorMessage
        }
    }
}

