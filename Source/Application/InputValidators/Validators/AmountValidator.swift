//
//  AmountValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import Validator

private typealias € = L10n.Error.Input.Amount

struct AmountValidator: InputValidator {

    typealias Error = AmountError

    func validate(input: String) -> InputValidationResult<Amount> {
        let amount: Amount
        do {
            amount = try Amount(string: input)
        } catch let amountError as AmountError {
            return self.error(amountError)
        } catch {
            incorrectImplementation("AmountError should cover all errors")
        }

        return .valid(amount)
    }
}

extension AmountValidator.Error: InputError {

    var errorMessage: String {

        switch self {
        case .tooLarge(let max): return €.tooLarge(max.description)
        case .tooSmall(let min): return €.tooSmall(min.description)
        case .nonNumericString: return €.nonNumericString
        }
    }
}
