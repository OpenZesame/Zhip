//
//  InputValidationResult.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum InputValidationResult<Value> {
    case valid(Value)
    case invalid(Invalid)

    enum Invalid {
        case empty
        case error(message: String)
    }
}

extension InputValidationResult {

    var errorMessage: String? {
        guard case .invalid(.error(let errorMessage)) = self else { return nil }
        return errorMessage
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
}
