//
//  GasPrice.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-12-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct GasPrice: ExpressibleByAmount {
    public static let exponent: Int = -12
    public static let minSignificand: Value = 100

    public static var minValue: Value {
        return minSignificand * powerFactor
    }

    public let significand: Value
    public init(validSignificand significand: Value) {
        do {
            self.significand = try GasPrice.validate(significand: significand)
        } catch {
            fatalError("Invalid significand passed")
        }
    }
}

public extension GasPrice {
    func asAmount() -> Amount {
        return GasPrice.express(value: value, in: Amount.self)
    }
}
