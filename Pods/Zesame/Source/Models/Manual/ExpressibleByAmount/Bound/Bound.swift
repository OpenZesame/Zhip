//
//  Bound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol Bound {
    associatedtype Magnitude: Comparable & Numeric

    init(_ magnitude: Magnitude) throws
    init(_ magnitude: Int) throws
    init<UE>(amount unbound: UE) throws where UE: Unbound & ExpressibleByAmount
    init(zil: Zil) throws
    init(li: Li) throws
    init(qa: Qa) throws
}

public extension Bound where Self: AdjustableLowerbound, Self: AdjustableUpperbound {
    static func restoreDefaultBounds() {
        restoreDefaultMax()
        restoreDefaultMin()
    }
}
