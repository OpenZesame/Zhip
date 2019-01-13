//
//  InputValidationResult.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum Validation<Value, Error: InputError> {
    case valid(Value, remark: Error?)
    case invalid(Invalid)

    enum Invalid {
        case empty
        case error(Error)
    }
}

// MARK: - Convenience Getters
extension Validation {

    static func valid(_ value: Value) -> Validation {
        return .valid(value, remark: nil)
    }

    var value: Value? {
        switch self {
        case .valid(let value, _): return value
        default: return nil
        }
    }

    var isValid: Bool {
        return value != nil
    }

    var error: InputError? {
        guard case .invalid(.error(let error)) = self else { return nil }
        return error
    }

	var isError: Bool {
		return error != nil
	}
}
