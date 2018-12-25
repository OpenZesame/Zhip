//
//  InputValidationResult.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum Validation {
    case valid
    case empty
    case error(errorMessage: String)

    var isError: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }

    var isEmpty: Bool {
        switch self {
        case .empty: return true
        default: return false
        }
    }

    var isValid: Bool {
        switch self {
        case .valid: return true
        default: return false
        }
    }

    init<V, E>(invalid: InputValidationResult<V, E>.Invalid) {
        switch invalid {
        case .empty: self = .empty
        case .error(let error): self = .error(errorMessage: error.errorMessage)
        }
    }

    func equalsTreatingAllErrorsAsOne(_ other: Validation) -> Bool {
        switch (self, other) {
        case (.valid, .valid): return true
        case (.empty, .empty): return true
        case (.error, .error): return true
        default: return false
        }
    }
}

import UIKit
extension Validation {
    enum Color {
        static let valid: UIColor = .teal
        static let error: UIColor = .bloodRed
        static let empty: UIColor = .silverGrey
    }
}

enum InputValidationResult<Value, ValidationError: InputError> {
    case valid(Value)
    case invalid(Invalid)

    enum Invalid {
        case empty
        case error(ValidationError)
    }

    var validation: Validation {
        switch self {
        case .invalid(let invalid):
            switch invalid {
            case .empty: return .empty
            case .error(let error): return .error(errorMessage: error.errorMessage)
            }
        case .valid: return .valid
        }
    }
}

extension InputValidationResult {

    var error: InputError? {
        guard case .invalid(.error(let error)) = self else { return nil }
        return error
    }

    var value: Value? {
        guard case .valid(let value) = self else { return nil }
        return value
    }

    var isValid: Bool {
        return value != nil
    }
}

protocol InputError: Swift.Error {
    var errorMessage: String { get }
    func isEqual(_ error: InputError) -> Bool
}

extension InputError {
    func isEqual(_ error: InputError) -> Bool {
        return true
    }
}

extension InputValidationResult: Equatable {
    static func == <V, E>(lhs: InputValidationResult<V, E>, rhs: InputValidationResult<V, E>) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid): return true
        case (.invalid(.empty), .invalid(.empty)): return true
        case (.invalid(.error(let lhsError)), .invalid(.error(let rhsError))): return lhsError.isEqual(rhsError)
        default: return false
        }
    }
}
