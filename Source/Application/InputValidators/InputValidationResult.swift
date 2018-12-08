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
        switch self {
        case .invalid(let invalid):
            switch invalid {
            case .error(let errorMessage): return errorMessage
            case .empty: return nil
            }
        case .valid: return nil
        }
    }
}

protocol InputError: Swift.Error {
    var errorMessage: String { get }
}
