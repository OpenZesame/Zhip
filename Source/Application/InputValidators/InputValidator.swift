//
//  InputValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Validator

protocol InputValidator {
    associatedtype InputType: Validatable
    associatedtype Error: InputError
    func validate(input: InputType?) -> InputValidationResult
    func validate(input: InputType) -> InputValidationResult
}

extension InputValidator {
    func validate(input: InputType?) -> InputValidationResult {
        guard let input = input else { return .invalid(.empty) }
        return validate(input: input)
    }

    func error(_ error: Error) -> InputValidationResult {
        return .invalid(.error(message: error.errorMessage))
    }
}

extension InputValidator where Self: ValidationRulesOwner {
    func validate(input: InputType) -> InputValidationResult {
        let validationResult = input.validate(rules: rules)
        switch validationResult {
        case .valid: return .valid
        case .invalid(let errors):
            guard let inputError = errors.first as? InputError else { incorrectImplementation("Expected Input error") }
            return .invalid(.error(message: inputError.errorMessage))
        }
    }
}

// MARK: - String to Double
extension InputValidator where InputType == Double {
    func validate(string: String?) -> InputValidationResult {
        guard let input = string, let double = Double(input) else { return InputValidationResult.invalid(.empty) }
        return validate(input: double)
    }
}
