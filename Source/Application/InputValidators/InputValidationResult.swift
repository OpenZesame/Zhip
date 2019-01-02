//
//  InputValidationResult.swift
//  Zhip
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
}

extension Validation: ValidationConvertible {
    var validation: Validation { return self }
}

extension Validation: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty: return "empty"
        case .valid: return "valid"
        case .error(let errorMsg): return "error: \(errorMsg)"
        }
    }
}

extension Validation: Equatable {
    static func == (lhs: Validation, rhs: Validation) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid): return true
        case (.empty, .empty): return true
        case (.error(let lhsError), .error(let rhsError)): return lhsError == rhsError
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
protocol ValidationConvertible {
    var validation: Validation { get }
}
enum InputValidationResult<Value, ValidationError: InputError>: ValidationConvertible {
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

extension InputValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .valid: return "Valid"
        case .invalid(let invalid):
            switch invalid {
            case .empty: return "empty"
            case .error(let error): return "error: \(error.description)"
            }
        }
    }
}

extension InputValidationResult {

    var error: InputError? {
        guard case .invalid(.error(let error)) = self else { return nil }
        return error
    }

	var isError: Bool {
		return error != nil
	}

    var value: Value? {
        guard case .valid(let value) = self else { return nil }
        return value
    }

    var isValid: Bool {
        return value != nil
    }
}

public protocol InputError: Swift.Error, CustomStringConvertible {
    var errorMessage: String { get }
    func isEqual(_ error: InputError) -> Bool
}

public extension CustomStringConvertible where Self: InputError {
    var description: String {
        return errorMessage
    }
}

public extension InputError {
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
