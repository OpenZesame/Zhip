//
//  ZilAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct ZilAmount: ExpressibleByAmount, Upperbound, Lowerbound {
    public typealias Magnitude = Zil.Magnitude
    public static let minMagnitude: Zil.Magnitude = 0

    public static let maxMagnitude: Zil.Magnitude = 21_000_000_000
    public static let unit: Unit = .zil
    public let magnitude: Magnitude

    public init(valid magnitude: Magnitude) {
        do {
            self.magnitude = try ZilAmount.validate(magnitude: magnitude)
        } catch {
            fatalError("Invalid magnitude passed: `\(magnitude)`, error: `\(error)`")
        }
    }
}
