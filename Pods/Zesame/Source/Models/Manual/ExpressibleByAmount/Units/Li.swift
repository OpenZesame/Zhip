//
//  Li.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Li: ExpressibleByAmount {
    public typealias Magnitude = Double
    public static let unit: Unit = .li
    public let magnitude: Magnitude

    public init(magnitude: Magnitude) {
        do {
            self.magnitude = try Li.validate(magnitude: magnitude)
        } catch {
            fatalError("Invalid magnitude passed")
        }
    }
}

// MARK: ExpressibleByAmount
public extension Li {
    var inLi: Li { return self }
}
