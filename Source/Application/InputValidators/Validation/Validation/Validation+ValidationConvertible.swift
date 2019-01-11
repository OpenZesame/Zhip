//
//  Validation+ValidationConvertible.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - ValidationConvertible
extension Validation: ValidationConvertible {
    var validation: AnyValidation {
        switch self {
        case .invalid(let invalid):
            switch invalid {
            case .empty: return .empty
            case .warning(let warning): return .warningMessage(warning.errorMessage)
            case .error(let error): return .errorMessage(error.errorMessage)
            }
        case .valid: return .valid
        }
    }
}
