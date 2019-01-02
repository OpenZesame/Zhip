//
//  ExpressibleByAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

/// A type representing an Zilliqa amount in any denominator, specified by the `Unit` and the value measured
/// in said unit by the `Magnitude`. For convenience any type can be converted to the default units, such as
/// Zil, Li, and Qa. Any type can also be initialized from said units. For convenience we can perform arthimetic
// between two instances of the same type but we can also perform artithmetic between two different types, e.g.
// Zil(2) + Li(3_000_000) // 5 Zil
/// We can also compare them of course. An extension on The Magnitude allows for syntax like 3.zil
/// analogously for Li and Qa.
public protocol ExpressibleByAmount:
Codable,
Comparable,
CustomDebugStringConvertible,
ExpressibleByIntegerLiteral,
ExpressibleByFloatLiteral,
ExpressibleByStringLiteral
where Magnitude == BigInt {

    associatedtype Magnitude

    // These are the two most important properties of the `ExpressibleByAmount` protocol,
    // the unit in which the value - the magnitude is measured.
    static var unit: Unit { get }
    var qa: Magnitude { get }

    // "Designated" initializer
    init(valid: Magnitude)

    // Convenience translations
    var asLi: Li { get }
    var asZil: Zil { get }
    var asQa: Qa { get }

    static func validate(value: Magnitude) throws -> Magnitude
    
    // Convenience initializers
    init(zil zilString: String) throws
    init(li liString: String) throws
    init(qa qaString: String) throws
}

public extension ExpressibleByAmount {
    var unit: Unit { return Self.unit }

    static var powerOf: String {
        return unit.powerOf
    }
}
