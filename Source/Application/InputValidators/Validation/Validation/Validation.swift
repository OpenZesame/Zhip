//
//  InputValidationResult.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum Validation<Value, InvalidReason: InputError> {
    case valid(Value)
    case invalid(Invalid)

    enum Invalid {
        case empty
        case warning(InvalidReason)
        case error(InvalidReason)
    }
}

// MARK: - Convenience Getters
extension Validation {
    var value: Value? {
        guard case .valid(let value) = self else { return nil }
        return value
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

    var warning: InputError? {
        guard case .invalid(.warning(let warning)) = self else { return nil }
        return warning
    }

    var isWarning: Bool {
        return warning != nil
    }
}
