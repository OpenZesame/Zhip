//
//  AnyValidation.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

enum AnyValidation {
    case valid
    case empty
    case warningMessage(String)
    case errorMessage(String)
}

// MARK: - Convenience Init
extension AnyValidation {
    init<V, E>(invalid: Validation<V, E>.Invalid) {
        switch invalid {
        case .empty: self = .empty
        case .error(let error): self = .errorMessage(error.errorMessage)
        case .warning(let warning): self = .warningMessage(warning.errorMessage)
        }
    }
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

    var isWarning: Bool {
        switch self {
        case .warningMessage: return true
        default: return false
        }
    }

    var isError: Bool {
        switch self {
        case .errorMessage: return true
        default: return false
        }
    }

    var isErrorOrWarning: Bool {
        return isError || isWarning
    }

    var isValidOrEmpty: Bool {
        return isEmpty || isValid
    }
}

// MARK: - ValidationConvertible
extension AnyValidation: ValidationConvertible {
    var validation: AnyValidation { return self }
}
