//
//  Qa.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Qa: ExpressibleByAmount {
    public typealias Magnitude = Double
    public static let unit: Unit = .qa
    public let magnitude: Magnitude

    public init(magnitude: Magnitude) {
        do {
            self.magnitude = try Qa.validate(magnitude: magnitude)
        } catch {
            fatalError("Invalid magnitude passed")
        }
    }
}

// MARK: ExpressibleByAmount
public extension Qa {
    var inQa: Qa { return self }
}
