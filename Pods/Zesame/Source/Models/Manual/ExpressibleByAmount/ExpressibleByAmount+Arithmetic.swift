//
//  ExpressibleByAmount+Arithemtic.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

private extension ExpressibleByAmount where Self: Bound {
    static func oper(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) throws -> Self {
        return try Self.init(calc(lhs.magnitude, rhs.magnitude))
    }
}

private extension ExpressibleByAmount where Self: NoLowerbound {
    static func oper(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) -> Self {
        return Self.init(valid: calc(lhs.magnitude, rhs.magnitude))
    }
}

private extension ExpressibleByAmount where Self: NoUpperbound {
    static func oper(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) -> Self {
        return Self.init(valid: calc(lhs.magnitude, rhs.magnitude))
    }
}

public extension NoUpperbound where Self: ExpressibleByAmount {
    static func + (lhs: Self, rhs: Self) -> Self {
        return Self.init(valid: lhs.magnitude + rhs.magnitude)
    }
}

public extension Upperbound where Self: ExpressibleByAmount {
    static func + (lhs: Self, rhs: Self) throws -> Self {
        return try oper(lhs, rhs) { $0 + $1 }
    }
}

public extension NoLowerbound where Self: ExpressibleByAmount {
    static func - (lhs: Self, rhs: Self) -> Self {
        return oper(lhs, rhs) { $0 - $1 }
    }
}

public extension Lowerbound where Self: ExpressibleByAmount {
    static func - (lhs: Self, rhs: Self) throws -> Self {
        return try oper(lhs, rhs) { $0 - $1 }
    }
}


public func + <A, B>(lhs: A, rhs: B) throws -> A where A: ExpressibleByAmount & Bound, B: ExpressibleByAmount {
    return try A(qa: lhs.inQa + rhs.inQa)
}

public func + <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount & Unbound, B: ExpressibleByAmount {
    return A(qa: lhs.inQa + rhs.inQa)
}

public func - <A, B>(lhs: A, rhs: B) throws -> A where A: ExpressibleByAmount & Bound, B: ExpressibleByAmount {
    return try A(qa: lhs.inQa - rhs.inQa)
}

public func - <A, B>(lhs: A, rhs: B) -> A where A: ExpressibleByAmount & Unbound, B: ExpressibleByAmount {
    return A(qa: lhs.inQa - rhs.inQa)
}
