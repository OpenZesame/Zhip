//
//  Gas.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Gas {
    public let price: Price
    public let limit: Limit

    public init(price: Price, limit: Limit) {
        self.price = price
        self.limit = limit
    }

    public struct Price {
        public let price: Double
        public init(double price: Double) throws {
            guard price > 0 else { throw Error.negativePrice }
            self.price = price
        }

        public enum Error: Int, Swift.Error, Equatable {
            case negativePrice
        }
    }

    public struct Limit {
        public let limit: Double
        public init(double limit: Double) throws {
            guard limit > 0 else { throw Error.negativeLimit }
            self.limit = limit
        }

        public enum Error: Int, Swift.Error, Equatable {
            case negativeLimit
        }
    }
}

public extension Gas {
    init(rawPrice: Double, rawLimit: Double) throws {
        let price = try Price(double: rawPrice)
        let limit = try Limit(double: rawLimit)
        self.init(price: price, limit: limit)
    }
}

extension Gas.Price: ExpressibleByFloatLiteral {}
public extension Gas.Price {
    /// This `ExpressibleByFloatLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(floatLiteral value: Double) {
        do {
            try self = Gas.Price(double: value)
        } catch {
            fatalError("The `Double` value used to create price was invalid, error: \(error)")
        }
    }
}

extension Gas.Price: ExpressibleByIntegerLiteral {}
public extension Gas.Price {
    /// This `ExpressibleByIntegerLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(integerLiteral value: Int) {
        do {
            try self = Gas.Price(double: Double(value))
        } catch {
            fatalError("The `Int` value used to create price was invalid, error: \(error)")
        }
    }
}


extension Gas.Limit: ExpressibleByFloatLiteral {}
public extension Gas.Limit {
    /// This `ExpressibleByFloatLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(floatLiteral value: Double) {
        do {
            try self = Gas.Limit(double: value)
        } catch {
            fatalError("The `Double` value used to create limit was invalid, error: \(error)")
        }
    }
}

extension Gas.Limit: ExpressibleByIntegerLiteral {}
public extension Gas.Limit {
    /// This `ExpressibleByIntegerLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(integerLiteral value: Int) {
        do {
            try self = Gas.Limit(double: Double(value))
        } catch {
            fatalError("The `Int` value used to create limit was invalid, error: \(error)")
        }
    }
}

