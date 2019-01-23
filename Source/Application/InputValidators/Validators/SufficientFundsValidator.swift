//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
            return .invalid(.error(.amountError(error)))
        } catch {
            incorrectImplementation("AmountError should cover all errors")
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

