//
//  ExpressibleByAmount+Arithemtic.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ExpressibleByAmount where Self: Bound {
    private static func qaFrom(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) throws -> Self {
        return try Self.init(qa: calc(lhs.qa, rhs.qa))
    }

    static func + (lhs: Self, rhs: Self) throws -> Self {
        return try qaFrom(lhs, rhs) { $0 + $1 }
    }

    static func * (lhs: Self, rhs: Self) throws -> Self {
        return try qaFrom(lhs, rhs) { $0 * $1 }
    }

    static func - (lhs: Self, rhs: Self) throws -> Self {
        return try qaFrom(lhs, rhs) { $0 - $1 }
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    static func - (lhs: Self, rhs: Self) -> Self {
        return qaFrom(lhs, rhs) { $0 - $1 }
    }

    private static func qaFrom(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) -> Self {
        return Self.init(qa: calc(lhs.qa, rhs.qa))
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return Self.init(qa: lhs.qa + rhs.qa)
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        return Self.init(qa: lhs.qa * rhs.qa)
    }
}

public func + <A, B>(lhs: A, rhs: B) throws -> A where A: ExpressibleByAmount & Bound, B: ExpressibleByAmount {
    return try A(qa: lhs.qa + rhs.qa)
}

public func + <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount & Unbound, B: ExpressibleByAmount {
    return A(qa: lhs.qa + rhs.qa)
}

public func - <A, B>(lhs: A, rhs: B) throws -> A where A: ExpressibleByAmount & Bound, B: ExpressibleByAmount {
    return try A(qa: lhs.qa - rhs.qa)
}

public func - <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount & Unbound, B: ExpressibleByAmount {
    return A(qa: lhs.qa - rhs.qa)
}
