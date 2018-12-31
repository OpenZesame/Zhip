//
//  ExpressibleByAmount+Initializers.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation


public extension ExpressibleByAmount where Self: Upperbound, Self: Lowerbound {

    static func validate(magnitude: Magnitude) throws -> Magnitude {
        try AnyLowerbound(self).throwErrorIfNotWithinBounds(magnitude)
        try AnyUpperbound(self).throwErrorIfNotWithinBounds(magnitude)
        return magnitude
    }
}

public extension ExpressibleByAmount where Self: Upperbound & NoLowerbound {

    static func validate(magnitude: Magnitude) throws -> Magnitude {
        try AnyUpperbound(self).throwErrorIfNotWithinBounds(magnitude)
        return magnitude
    }
}

public extension ExpressibleByAmount where Self: Lowerbound, Self: NoUpperbound {

    static func validate(magnitude: Magnitude) throws -> Magnitude {
        try AnyLowerbound(self).throwErrorIfNotWithinBounds(magnitude)
        return magnitude
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    static func validate(magnitude: Magnitude) throws -> Magnitude {
        return magnitude
    }
}

public extension ExpressibleByAmount {
    static func validate(magnitude string: String) throws -> Magnitude {
        guard let magnitude = Magnitude(string) else {
            throw AmountError<Self>.nonNumericString
        }
        return try validate(magnitude: magnitude)
    }

}

public extension ExpressibleByAmount where Self: Bound {


    init(_ magnitude: Magnitude) throws {
        let validated = try Self.validate(magnitude: magnitude)
        self.init(valid: validated)
    }

    init(_ magnitude: Int) throws {
        try self.init(Magnitude(magnitude))
    }

    init(floatLiteral double: Double) {
        do {
            try self = Self.init(double)
        } catch {
            fatalError("The `Double` value (`\(double)`) passed was invalid, error: \(error)")
        }
    }

    init(integerLiteral int: Int) {
        do {
            try self = Self.init(Magnitude(int))
        } catch {
            fatalError("The `Int` value (`\(int)`) passed was invalid, error: \(error)")
        }
    }

    init(magnitude string: String) throws {
        try self.init(try Self.validate(magnitude: string))
    }

    init(stringLiteral string: String) {
        do {
            try self = Self(magnitude: string)
        } catch {
            fatalError("The `String` value (`\(string)`) passed was invalid, error: \(error)")
        }
    }

    init(zil zilString: String) throws {
        try self.init(zil: try Zil(magnitude: zilString))
    }
    init(li liString: String) throws {
        try self.init(li: try Li(magnitude: liString))
    }
    init(qa qaString: String) throws {
        try self.init(qa: try Qa(magnitude: qaString))
    }

    init<UE>(amount unbound: UE) throws where UE: Unbound & ExpressibleByAmount {
        try self.init(unbound.valueMeasured(in: Self.unit))
    }

    init(zil: Zil) throws {
        // using init:unbound
        try self.init(amount: zil)
    }

    init(li: Li) throws {
        // using init:unbound
        try self.init(amount: li)
    }

    init(qa: Qa) throws {
        // using init:unbound
        try self.init(amount: qa)
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    init(magnitude int: Int) {
        self.init(valid: Magnitude(int))
    }

    init(floatLiteral double: Double) {
        self.init(valid: double)
    }

    init(integerLiteral int: Int) {
        self.init(magnitude: int)
    }

    init(magnitude string: String) throws {
        self.init(valid: try Self.validate(magnitude: string))
    }

    init(stringLiteral string: String) {
        do {
            try self = Self(magnitude: string)
        } catch {
            fatalError("The `String` value (`\(string)`) passed was invalid, error: \(error)")
        }
    }

    init<UE>(amount unbound: UE) where UE: Unbound & ExpressibleByAmount {
        self.init(valid: unbound.valueMeasured(in: Self.unit))
    }

    init(zil: Zil) {
        self.init(amount: zil)
    }

    init(li: Li) {
        self.init(amount: li)
    }

    init(qa: Qa) {
        self.init(amount: qa)
    }

    init(zil zilString: String) throws {
        self.init(zil: try Zil(magnitude: zilString))
    }

    init(li liString: String) throws {
        self.init(li: try Li(magnitude: liString))
    }

    init(qa qaString: String) throws {
        self.init(qa: try Qa(magnitude: qaString))
    }
}
