//
//  ExpressibleByAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

public enum AmountError: Swift.Error {
    case nonNumericString
    case tooSmall(min: Double)
    case tooLarge(max: Double)
}

public protocol ExpressibleByAmount: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, Comparable, Codable, CustomStringConvertible, CustomDebugStringConvertible {
    typealias Value = Double

    /// The unit used to measure the amount. If the `Self` is `Amount` to send to address then the exponent is
    /// the default of `0`, meaning that we measure in whole Zillings. But we might measure `GasPrice` in units
    /// being worth less, being measure in units of 10^-12, then this property will have the value `-12`
    static var exponent: Int { get }
    static var minSignificand: Value { get }
    static var minValue: Value { get }
    static var maxSignificand: Value { get }
    static var maxValue: Value { get }

    var significand: Value { get }

    init(validSignificand: Value)
    init(significand: Value) throws
    init(string: String) throws
}

public extension ExpressibleByAmount {
    static var exponent: Int { return 0 }

    /// The decimal exponentiation of the exponent, i.e. the value resulting from 10^exponent
    /// see `exponent` property for more info.
    static var powerFactor: Double {
        return pow(10, Double(exponent))
    }
}

public extension ExpressibleByAmount {
    var value: Value {
        return significand * Self.powerFactor
    }
}

public extension ExpressibleByAmount {

    static var totalSupply: Value {
        return 21_000_000_000 // 21 billion Zillings is the total supply
    }

    static var maxSignificand: Value {
        return maxValue / powerFactor
    }

    static var minSignificand: Value {
        return minValue / powerFactor
    }

    static var minValue: Value {
        return 0
    }

    static var maxValue: Value {
        return totalSupply
    }
}

public extension ExpressibleByAmount {
    static var minimum: Self {
        return Self(validSignificand: minSignificand)
    }

    static var maximum: Self {
        return Self(validSignificand: maxSignificand)
    }
}

public extension ExpressibleByAmount {
    static func express<Unit>(value: Value, in unit: Unit.Type) -> Unit where Unit: ExpressibleByAmount {
        return Unit(validSignificand: value / Unit.powerFactor)
    }
}

// MARK: - Initializers
public extension ExpressibleByAmount {

    @discardableResult
    static func validate(significand: Value) throws -> Value {
        guard significand <= Self.maxSignificand else {
            throw AmountError.tooLarge(max: Self.maxValue)
        }

        guard significand >= Self.minSignificand else {
            throw AmountError.tooSmall(min: Self.minValue)
        }
        return significand
    }

    init(significand: Value) throws {
        self.init(validSignificand: try Self.validate(significand: significand))
    }

    init(string: String) throws {
        guard let significand = Value(string) else {
            throw AmountError.nonNumericString
        }

        try self.init(significand: significand)
    }

    init(significand int: Int) throws {
        try self.init(significand: Value(int))
    }
}

// MARK: - Comparable
public extension ExpressibleByAmount {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: - Encodable
public extension ExpressibleByAmount {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}

// MARK: - Decodable
public extension ExpressibleByAmount {
     init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}

// MARK: - ExpressibleByIntegerLiteral
public extension ExpressibleByAmount {
    /// This `ExpressibleByIntegerLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    init(integerLiteral integerValue: Int) {
        do {
            try self = Self(significand: integerValue)
        } catch {
            fatalError("The `Int` value (`\(integerValue)`) used to create amount was invalid, error: \(error)")
        }
    }
}

// MARK: - ExpressibleByStringLiteral
public extension ExpressibleByAmount {
    /// This `ExpressibleByStringLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    init(stringLiteral stringValue: String) {
        do {
            try self = Self(string: stringValue)
        } catch {
            fatalError("The `String` value (`\(stringValue)`) used to create amount was invalid, error: \(error)")
        }
    }
}

// MARK: - CustomStringConvertible
public extension ExpressibleByAmount {
    var description: String {
        return value.description
    }
}

// MARK: - CustomDebugStringConvertible
public extension ExpressibleByAmount {
    var debugDescription: String {
        return "\(significand)E\(Self.exponent)"
    }
}
