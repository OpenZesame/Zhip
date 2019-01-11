//
//  Validation+Equatable.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

extension Validation: Equatable {
    static func == <V, E>(lhs: Validation<V, E>, rhs: Validation<V, E>) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid): return true
        case (.invalid(.empty), .invalid(.empty)): return true
        case (.invalid(.error(let lhsError)), .invalid(.error(let rhsError))): return lhsError.isEqual(rhsError)
        case (.invalid(.warning(let lhsError)), .invalid(.warning(let rhsError))): return lhsError.isEqual(rhsError)
        default: return false
        }
    }
}
