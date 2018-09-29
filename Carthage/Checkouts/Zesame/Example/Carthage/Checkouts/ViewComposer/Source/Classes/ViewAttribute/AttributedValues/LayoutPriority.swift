//
//  LayoutPriority.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-05-31.
//
//

import Foundation

public enum LayoutPriority {
    case required
    case low
    case high
    case custom(Float)
}

extension LayoutPriority {
    var value: UILayoutPriority {
        switch self {
        case .required:
            return .required
        case .low:
            return .defaultLow
        case .high:
            return .defaultHigh
        case .custom(let prio):
            return UILayoutPriority(rawValue: prio)
        }
    }
}
