//
//  Zil.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Zil: ExpressibleByAmount {
    public typealias Magnitude = Double
    public static let unit: Unit = .zil
    public static var totalSupply = Zil.max
    public let magnitude: Magnitude

    public init(magnitude: Magnitude) {
        do {
            self.magnitude = try Zil.validate(magnitude: magnitude)
        } catch {
            fatalError("Invalid magnitude passed: `\(magnitude)`, error: `\(error)`")
        }
    }
}

// MARK: ExpressibleByAmount
public extension Zil {
    var inZil: Zil { return self }
}
