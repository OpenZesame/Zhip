//
//  Validation+CustomStringConvertible.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

extension Validation: CustomStringConvertible {
    var description: String {
        switch self {
        case .valid(_, let remark):
            if let remark = remark {
                return "Valid with remark: \(remark.description)"
            } else {
                return "Valid"
            }
        case .invalid(let invalid):
            switch invalid {
            case .empty: return "empty"
            case .error(let error): return "error: \(error.description)"
            }
        }
    }
}
