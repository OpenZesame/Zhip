//
//  InputValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Validator

protocol InputValidator {
    associatedtype Input
    associatedtype Output
    associatedtype Error: InputError
    func validate(input: Input?) -> InputValidationResult<Output, Error>
    func validate(input: Input) -> InputValidationResult<Output, Error>
}

extension InputValidator {
    func validate(input: Input?) -> InputValidationResult<Output, Error> {
        guard let input = input else { return .invalid(.empty) }
        return validate(input: input)
    }

    func error(_ error: Error) -> InputValidationResult<Output, Error> {
        return .invalid(.error(error))
    }
}

extension InputValidator where Self: ValidationRulesOwner, Self.RuleInput == Input, Output == Input {
    func validate(input: Input) -> InputValidationResult<Output, Error> {
        let validationResult = input.validate(rules: rules)
        switch validationResult {
        case .valid: return .valid(input)
        case .invalid(let errors):
            guard let inputError = errors.first as? Error else { incorrectImplementation("Expected error of type `Self.Error`") }
            return .invalid(.error(inputError))
        }
    }
}

// MARK: - String to Double
extension InputValidator where Input == Double, Output == Double {
    func validate(string: String?) -> InputValidationResult<Output, Error> {
        guard let input = string, let double = Double(input) else { return InputValidationResult.invalid(.empty) }
        return validate(input: double)
    }
}
