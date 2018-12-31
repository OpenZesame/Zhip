//
//  Unbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol Unbound: NoLowerbound & NoUpperbound {
    associatedtype Magnitude: Comparable & Numeric
    init(_ magnitude: Magnitude)
    init(magnitude: Int)
    init<UE>(amount unbound: UE) where UE: Unbound & ExpressibleByAmount
    init(zil: Zil)
    init(li: Li)
    init(qa: Qa)
}

extension Upperbound where Self: ExpressibleByAmount {
    public static var max: Self {
        do {
            return try Self(maxMagnitude)
        } catch {
            fatalError("We should always be able to create upper bound")
        }
    }
}
