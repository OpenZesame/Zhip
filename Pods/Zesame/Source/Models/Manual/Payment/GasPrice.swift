//
//  GasPrice.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-12-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct GasPrice: ExpressibleByAmount {
    public typealias Magnitude = Qa.Magnitude
    public static let minMagnitude: Magnitude = 1_000_000_000
    public static let maxMagnitude = Qa.max
    public static let unit: Unit = .qa
    public let magnitude: Magnitude

    public init(magnitude: Magnitude) {
        self.magnitude = magnitude
    }
}

public extension GasPrice {
    var amount: Qa.Magnitude {
        return magnitude
    }
}

public extension GasPrice {
    static var minInLi: Int {
        return Int(GasPrice.min.inLi.magnitude)
    }
}
