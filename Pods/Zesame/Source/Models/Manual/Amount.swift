//
//  Amount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

public struct Amount: ExpressibleByAmount {
    public let significand: Value

    public init(validSignificand significand: Value) {
        do {
            self.significand = try Amount.validate(significand: significand)
        } catch {
            fatalError("Invalid significand passed")
        }
    }
}

public extension Amount {
    func asGasPrice() -> GasPrice {
        return Amount.express(value: value, in: GasPrice.self)
    }
}
