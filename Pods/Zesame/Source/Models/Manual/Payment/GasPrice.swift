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

    public let magnitude: Magnitude

    /// By default GasPrice has a lowerobund of 1000 Li, i.e 1 000 000 000 Qa, this can be changed.
    public static let minMagnitudeDefault: Magnitude = Li(1000).inQa.magnitude
    public static var minMagnitude = minMagnitudeDefault {
        willSet {
            guard newValue <= maxMagnitude else {
                fatalError("Cannot set minMagnitude to greater than maxMagnitude")
            }
        }
    }

    /// By default GasPrice has an upperbound of 10 Zil, this can be changed.
    public static let maxMagnitudeDefault: Magnitude = Zil(10).inQa.magnitude
    public static var maxMagnitude = maxMagnitudeDefault {
        willSet {
            guard newValue >= minMagnitude else {
                fatalError("Cannot set maxMagnitude to less than minMagnitude")
            }
        }
    }

    public init(valid magnitude: Magnitude) {
        do {
            self.magnitude = try GasPrice.validate(magnitude: magnitude)
        } catch {
            fatalError("Invalid magnitude passed: `\(magnitude)`, error: `\(error)`")
        }
    }
}

public extension GasPrice {
    var amount: Qa.Magnitude {
        return magnitude
    }
}

public extension GasPrice {
    static var minInLiAsInt: Int {
        return Int(GasPrice.min.inLi.magnitude)
    }
}
