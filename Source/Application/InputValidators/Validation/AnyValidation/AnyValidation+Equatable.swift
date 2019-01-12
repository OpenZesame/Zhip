//
//  AnyValidation+Equatable.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - Equatable
extension AnyValidation: Equatable {
    static func == (lhs: AnyValidation, rhs: AnyValidation) -> Bool {
        switch (lhs, rhs) {
        case (.valid(let lhsRemark), .valid(let rhsRemark)): return lhsRemark == rhsRemark
        case (.empty, .empty): return true
        case (.errorMessage(let lhsError), .errorMessage(let rhsError)): return lhsError == rhsError
        default: return false
        }
    }
}
