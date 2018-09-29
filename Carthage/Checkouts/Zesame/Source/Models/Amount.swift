//
//  Amount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

extension Double {
    var decimal: Double {
        return truncatingRemainder(dividingBy: 1)
    }
}

private extension Amount {
    static var inversionOfSmallestFraction: Double {
        return pow(10, Double(Amount.decimals))
    }
}

public struct Amount {
    public static let totalSupply: Double = 21000000000 // 21 billion Zillings is the total supply
    public static let decimals: Int = 12
    /// Actually storing the value inside a Double results in limitations, we can only store 15 digits without losing precision. Please take a look at the table below to see the number of decimals you get precision with given the integer part:
    /// 20 999 999 999.9991            //11 + 4
    ///  9 999 999 999.99991           //10 + 5
    ///    999 999 999.999991          // 9 + 6
    ///     99 999 999.9999991         // 8 + 7
    ///      9 999 999.99999991        // 7 + 8
    ///        999 999.999999991       // 6 + 9
    ///         99 999.9999999991      // 5 + 10
    ///          9 999.99999999991     // 4 + 11
    ///            999.999999999991    // 3 + 12
    /// However, this limitations might be okay, if you are sending such big amounts as 9 billion Zillings, the first of all, congrats, you are a rich person, second, it might be okay to be constrained to 5 decimals sending such a big amount.

    public let amount: Double
    public init(double amount: Double, smallFractionRule: SmallFractionRule = .throwError) throws {
        guard amount >= 0 else { throw Error.amountWasNegative }
        guard amount <= Amount.totalSupply else { throw Error.amountExceededTotalSupply }

        var amount = amount

        let iosf = Amount.inversionOfSmallestFraction
        let overflowsMaximumDecimalPrecision = (amount*iosf).decimal > 0
        if overflowsMaximumDecimalPrecision {
            switch smallFractionRule {
            case .throwError: throw Error.amountContainsTooSmallFractions
            case .truncate: amount = (amount * iosf).rounded() / iosf
            }
        }
        self.amount = amount
    }

    public enum SmallFractionRule: Int, Equatable {
        case truncate
        case throwError
    }

    public enum Error: Int, Swift.Error, Equatable {
        case amountWasNegative
        case amountExceededTotalSupply
        case amountContainsTooSmallFractions
    }
}

extension Amount: ExpressibleByFloatLiteral {}
public extension Amount {
    /// This `ExpressibleByFloatLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(floatLiteral value: Double) {
        do {
            try self = Amount(double: value)
        } catch {
            fatalError("The `Double` value used to create amount was invalid, error: \(error)")
        }
    }
}

extension Amount: ExpressibleByIntegerLiteral {}
public extension Amount {
    /// This `ExpressibleByIntegerLiteral` init can result in runtime crash if passed invalid values (since the protocol requires the initializer to be non failable, but the designated initializer is).
    public init(integerLiteral value: Int) {
        do {
            try self = Amount(double: Double(value))
        } catch {
            fatalError("The `Int` value used to create amount was invalid")
        }
    }
}

extension Amount: CustomStringConvertible {
    public var description: String {
        return "\(amount) ZILs"
    }
}

