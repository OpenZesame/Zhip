//
//  ExpressibleByAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// A type representing an Zilliqa amount in any denominator, specified by the `Unit` and the value measured
/// in said unit by the `Magnitude`. For convenience any type can be converted to the default units, such as
/// Zil, Li, and Qa. Any type can also be initialized from said units. Since the type conforms to `Numeric`
/// protocol we can perform arthimetic between two instances of the same type, but thanks to convenience
/// functions we can also perform artithmetic between two different types, e.g. Zil(2) + Li(3_000_000) // 5 Zil
/// We can also compare them of course. An extension on The Zil.Magnitude allows for syntax like 3.zil
/// analogously for Li and Qa.
public protocol ExpressibleByAmount: Numeric,
Codable,
Comparable,
CustomStringConvertible,
CustomDebugStringConvertible,
ExpressibleByFloatLiteral,
ExpressibleByStringLiteral
where Magnitude == Double {

    // These are the two most important properties of the `ExpressibleByAmount` protocol,
    // the unit in which the value - the magnitude is measured.
    static var unit: Unit { get }
    var magnitude: Magnitude { get }

    static var minMagnitude: Magnitude { get }
    static var min: Self { get }
    static var maxMagnitude: Magnitude { get }
    static var max: Self { get }

    // Convenience translations
    var inLi: Li { get }
    var inZil: Zil { get }
    var inQa: Qa { get }

    // The "designated" initializer
    init(magnitude: Magnitude)

    // Convenience initializers
    init(_ validating: Magnitude) throws
    init(_ validating: Int) throws
    init(_ validating: String) throws
    init(zil: Zil) throws
    init(li: Li) throws
    init(qa: Qa) throws
    init(zil zilString: String) throws
    init(li liString: String) throws
    init(qa qaString: String) throws
}

// MARK: - Convenience
public extension ExpressibleByAmount {
    var unit: Unit { return Self.unit }

    static var powerOf: String {
        return unit.powerOf
    }
}
