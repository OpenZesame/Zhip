//
//  ExpressibleByAmount+Initializers.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ExpressibleByAmount {

    static func validate(magnitude: Magnitude) throws -> Magnitude {
        guard magnitude >= minMagnitude else {
            throw AmountError.tooSmall(minMagnitudeIs: minMagnitude)
        }

        guard magnitude <= maxMagnitude else {
            throw AmountError.tooLarge(maxMagnitudeIs: maxMagnitude)
        }

        return magnitude
    }

    init(_ unvalidatedMagnitude: String) throws {
        guard let unvalidatedDouble = Double(unvalidatedMagnitude) else {
            throw AmountError.nonNumericString
        }
        try self.init(Magnitude.init(floatLiteral: unvalidatedDouble))
    }

    init(floatLiteral double: Double) {
        do {
            try self = Self.init(Magnitude.init(floatLiteral: double))
        } catch {
            fatalError("The `Double` value (`\(double)`) passed was invalid, error: \(error)")
        }
    }

    init(_ unvalidatedMagnitude: Magnitude) throws {
        let validated = try Self.validate(magnitude: unvalidatedMagnitude)
        self.init(magnitude: validated)
    }

    init(_ unvalidatedMagnitude: Int) throws {
        try self.init(Magnitude(unvalidatedMagnitude))
    }

    init(integerLiteral int: Int) {
        do {
            try self = Self(int)
        } catch {
            fatalError("The `Int` value (`\(int)`) passed was invalid, error: \(error)")
        }
    }

    init(stringLiteral string: String) {
        do {
            try self = Self(string)
        } catch {
            fatalError("The `String` value (`\(string)`) passed was invalid, error: \(error)")
        }
    }

    init(zil zilString: String) throws {
        try self.init(zil: try Zil(zilString))
    }

    init(li liString: String) throws {
        try self.init(li: try Li(liString))
    }

    init(qa qaString: String) throws {
        try self.init(qa: try Qa(qaString))
    }
}
