//
//  AmountValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import Validator

struct AmountValidator: InputValidator {
    typealias Error = Amount.Error

    func validate(input: String) -> InputValidationResult<Amount> {
        let amount: Amount
        do {
            amount = try Amount(string: input)
        } catch let amountError as Error {
            return self.error(amountError)
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
        return .valid(amount)
    }
}

extension Amount.Error: InputError {
    var errorMessage: String {
        let Message = L10n.Error.Input.Amount.self

        switch self {
        case .amountExceededTotalSupply: return Message.tooLarge(Amount.totalSupply.description)
        case .amountWasNegative: return Message.wasNegative
        case .nonNumericString: return Message.nonNumericString
        }
    }
}
