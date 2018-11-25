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
    enum Error {
        case amountTooSmall
        case amountTooLarge
    }

    func validate(input amount: Double) -> InputValidationResult {
        guard amount >= Amount.minimumAsDouble else { return error(Error.amountTooSmall) }
        guard amount <= Amount.maximumAsDouble else { return error(Error.amountTooLarge) }
        return .valid
    }
}

extension AmountValidator.Error: InputError {
    var errorMessage: String {
        let Message = L10n.Error.Input.Amount.self

        switch self {
        case .amountTooLarge: return Message.tooLarge(Amount.maximumAsDouble.description)
        case .amountTooSmall: return Message.tooSmall(Amount.minimumAsDouble.description)
        }
    }
}
