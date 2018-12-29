//
//  SufficientFundsValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-15.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import Validator

private typealias € = L10n.Error.Input.Amount

struct SufficientFundsValidator: InputValidator {
    enum Error: Swift.Error {
        case insufficientFunds
        case amountError(AmountError)
    }

    // swiftlint:disable:next large_tuple
    func validate(input: (amount: ZilAmount, gasPrice: GasPrice, balance: ZilAmount)) -> InputValidationResult<ZilAmount, Error> {
        let (amount, gasPrice, balance) = input

        do {
            let totalCost = try Payment.estimatedTotalCostOfTransaction(amount: amount, gasPrice: gasPrice)
            guard totalCost <= balance else {
                return self.error(Error.insufficientFunds)
            }
        } catch let error as AmountError {
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

