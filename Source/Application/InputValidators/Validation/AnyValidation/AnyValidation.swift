//
//  AnyValidation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

enum AnyValidation {
    case valid(withRemark: String?)
    case empty
    case errorMessage(String)
}

// MARK: - Convenience Getters
extension AnyValidation {
    var isValid: Bool {
        switch self {
        case .valid: return true
        default: return false
        }
    }

    var isEmpty: Bool {
        switch self {
        case .empty: return true
        default: return false
        }
    }

    var isError: Bool {
        switch self {
        case .errorMessage: return true
        default: return false
        }
    }
}

// MARK: - ValidationConvertible
extension AnyValidation: ValidationConvertible {
    var validation: AnyValidation { return self }
}
