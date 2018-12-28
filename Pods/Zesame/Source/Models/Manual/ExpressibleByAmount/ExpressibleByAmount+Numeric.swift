//
//  ExpressibleByAmount+Numeric.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ExpressibleByAmount {

    init?<T>(exactly source: T) where T : BinaryInteger {
        guard let magnitude = Magnitude(exactly: source) else {
            return nil
        }
        do {
            self = try Self(magnitude)
        } catch {
            return nil
        }
    }

    private static func oper(_ lhs: Self, _ rhs: Self, calc: (Magnitude, Magnitude) -> Magnitude) -> Self {
        return Self.init(magnitude: calc(lhs.magnitude, rhs.magnitude))
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        return oper(lhs, rhs) { $0 * $1 }
    }

    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return oper(lhs, rhs) { $0 + $1 }
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return oper(lhs, rhs) { $0 - $1 }
    }

    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

