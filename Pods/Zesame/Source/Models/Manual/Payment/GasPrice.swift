//
//  GasPrice.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-12-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct GasPrice: ExpressibleByAmount, AdjustableUpperbound, AdjustableLowerbound {

    public typealias Magnitude = Qa.Magnitude
    public static let unit: Unit = .qa

    public let qa: Magnitude

    /// By default GasPrice has a lowerobund of 1000 Li, i.e 1 000 000 000 Qa, this can be changed.
    public static let minInQaDefault: Magnitude = 1_000_000_000
    public static var minInQa = minInQaDefault {
        willSet {
            guard newValue <= maxInQa else {
                fatalError("Cannot set minInQa to greater than maxInQa, max: \(maxInQa), new min: \(newValue) (old: \(minInQa)")
            }
        }
    }

    /// By default GasPrice has an upperbound of 10 Zil, this can be changed.
    public static let maxInQaDefault: Magnitude = 10_000_000_000_000
    public static var maxInQa = maxInQaDefault {
        willSet {
            guard newValue >= minInQa else {
                fatalError("Cannot set maxInQa to less than minInQa, min: \(minInQa), new max: \(newValue) (old: \(maxInQa)")
            }
        }
    }

    public init(qa: Magnitude) throws {
        self.qa = try GasPrice.validate(value: qa)
    }
}
