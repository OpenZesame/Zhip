//
//  ExpressibleByAmount+Initializers.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ExpressibleByAmount where Self: Upperbound, Self: Lowerbound {

    static func validate(value: Magnitude) throws -> Magnitude {
        try AnyLowerbound(self).throwErrorIfNotWithinBounds(value)
        try AnyUpperbound(self).throwErrorIfNotWithinBounds(value)
        return value
    }
}

public extension ExpressibleByAmount where Self: Upperbound & NoLowerbound {

    static func validate(value: Magnitude) throws -> Magnitude {
        try AnyUpperbound(self).throwErrorIfNotWithinBounds(value)
        return value
    }
}

public extension ExpressibleByAmount where Self: Lowerbound, Self: NoUpperbound {

    static func validate(value: Magnitude) throws -> Magnitude {
        try AnyLowerbound(self).throwErrorIfNotWithinBounds(value)
        return value
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    static func validate(value: Magnitude) throws -> Magnitude {
        return value
    }
}
