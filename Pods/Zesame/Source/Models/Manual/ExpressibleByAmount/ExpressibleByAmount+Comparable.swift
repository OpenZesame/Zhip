//
//  ExpressibleByAmount+Comparable.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ExpressibleByAmount {

    static func == (lhs: Self, rhs: Self) -> Bool {
        let unitUsedForComparision: Unit = .qa
        return lhs.valueMeasured(in: unitUsedForComparision) == rhs.valueMeasured(in: unitUsedForComparision)
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let unitUsedForComparision: Unit = .qa
        return lhs.valueMeasured(in: unitUsedForComparision) < rhs.valueMeasured(in: unitUsedForComparision)
    }
}
