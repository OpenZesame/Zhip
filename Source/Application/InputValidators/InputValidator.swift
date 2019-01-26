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

import Validator

protocol InputValidator {
    associatedtype Input
    associatedtype Output
    associatedtype Error: InputError
    func validate(input: Input?) -> Validation<Output, Error>
    func validate(input: Input) -> Validation<Output, Error>
}

extension InputValidator {

    typealias Result = Validation<Output, Error>

    func validate(input: Input?) -> Result {
        guard let input = input else { return .invalid(.empty) }
        return validate(input: input)
    }

    func error(_ error: Error) -> Result {
        return .invalid(.error(error))
    }
}

extension InputValidator where Self: ValidationRulesOwner, Self.RuleInput == Input, Output == Input {
    func validate(input: Input) -> Result {
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
    func validate(string: String?) -> Result {
        guard let input = string, let double = Double(input) else { return Validation.invalid(.empty) }
        return validate(input: double)
    }
}
