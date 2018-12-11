//
//  Amount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

public struct Amount {
    public static let totalSupply: Int = 21_000_000_000 // 21 billion Zillings is the total supply

    public let amount: Int

    public init(number amount: Int) throws {
        guard amount >= 0 else { throw Error.amountWasNegative }
        guard amount <= Amount.totalSupply else { throw Error.amountExceededTotalSupply }
        self.amount = amount
    }

    public init(string: String) throws {
        guard let bigNumber = BigNumber(decimalString: string) else {
            throw Error.nonNumericString
        }

        guard bigNumber <= BigNumber(Amount.totalSupply) else {
            throw Error.amountExceededTotalSupply
        }

        try self.init(number: Int(bigNumber))
    }

    public enum Error: Int, Swift.Error, Equatable {
        case nonNumericString
        case amountWasNegative
        case amountExceededTotalSupply
    }
}

extension Amount: ExpressibleByIntegerLiteral {}
public extension Amount {
    /// This `ExpressibleByIntegerLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(integerLiteral value: Int) {
        do {
            try self = Amount(number: value)
        } catch {
            fatalError("The `Int` value (`\(value)`) used to create amount was invalid, error: \(error)")
        }
    }
}

extension Amount: ExpressibleByStringLiteral {}
public extension Amount {
    /// This `ExpressibleByStringLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(stringLiteral value: String) {
        do {
            guard let number = Int(value) else {
                throw Error.nonNumericString
            }
            try self = Amount(number: number)
        } catch {
            fatalError("The `String` value (`\(value)`) used to create amount was invalid, error: \(error)")
        }
    }
}

extension Amount: CustomStringConvertible {}
public extension Amount {
    var description: String {
        return "\(amount)"
    }
}

extension Amount: Equatable {}

extension Amount: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(amount.description)
    }
}

extension Amount: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}
