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

    func validate(input zil: String) -> InputValidationResult<ZilAmount, Error> {
        let amount: ZilAmount
        do {
            amount = try ZilAmount(zil: zil)
            guard amount > 0 else {
               throw Error.tooSmall(minMagnitudeIs: ZilAmount.minMagnitude)
            }
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
        case .tooLarge(let max): return €.tooLarge(Int(max).description)
        case .tooSmall(let min): return €.tooSmall(Int(min).description)
        case .nonNumericString: return €.nonNumericString
        }
    }
}

