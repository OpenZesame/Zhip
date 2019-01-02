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

    // "Designated" init, check bounds
    init(qa: Magnitude)

    /// Most important "convenience" init
    init(_ value: Magnitude)

    /// Various convenience inits
    init(_ doubleValue: Double)
    init(_ intValue: Int)
    init(_ stringValue: String) throws
    init<E>(_ other: E) where E: ExpressibleByAmount
    init(zil: Zil)
    init(li: Li)
    init(qa: Qa)
    init(zil: String) throws
    init(li: String) throws
    init(qa: String) throws
}

public extension ExpressibleByAmount where Self: Unbound {
    /// Most important "convenience" init
    init(_ value: Magnitude) {
        self.init(qa: Self.toQa(magnitude: value))
    }

    init(valid: Magnitude) {
        self.init(valid)
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    init(_ doubleValue: Double) {
        self.init(qa: Self.toQa(double: doubleValue))
    }

    init(_ intValue: Int) {
        self.init(Magnitude(intValue))
    }

    init(_ untrimmed: String) throws {
        let whiteSpacesRemoved = untrimmed.replacingOccurrences(of: " ", with: "")
        print("untrimmed: \(untrimmed), whiteSpacesRemoved: \(whiteSpacesRemoved)")
        if let mag = Magnitude(decimalString: whiteSpacesRemoved) {
            self = Self.init(mag)
        } else if let double = Double(whiteSpacesRemoved) {
            self.init(double)
        } else {
            throw AmountError<Self>.nonNumericString
        }
    }
}

public extension ExpressibleByAmount where Self: Unbound {
    init<E>(_ other: E) where E: ExpressibleByAmount {
        self.init(qa: other.qa)
    }

    init(zil: Zil) {
        self.init(zil)
    }

    init(li: Li) {
        self.init(li)
    }

    init(qa: Qa) {
        self.init(qa)
    }
}

public extension ExpressibleByAmount where Self: Unbound {
    init(zil zilString: String) throws {
        self.init(zil: try Zil.init(zilString))
    }

    init(li liString: String) throws {
        self.init(li: try Li(liString))
    }

    init(qa qaString: String) throws {
        self.init(qa: try Qa(qaString))
    }
}

// MARK: - ExpressibleByFloatLiteral
public extension ExpressibleByAmount where Self: Unbound {
    init(floatLiteral double: Double) {
        self.init(double)
    }
}

// MARK: - ExpressibleByIntegerLiteral
public extension ExpressibleByAmount where Self: Unbound {
    init(integerLiteral int: Int) {
        self.init(int)
    }
}

// MARK: - ExpressibleByStringLiteral
public extension ExpressibleByAmount where Self: Unbound {
    init(stringLiteral string: String) {
        do {
            try self = Self(string)
        } catch {
            fatalError("The `String` value (`\(string)`) passed was invalid, error: \(error)")
        }
    }
}
