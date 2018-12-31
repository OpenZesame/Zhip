//
//  UnboundAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct UnboundAmount<UnitSpecifyingType: UnitSpecifying>: ExpressibleByAmount, Unbound {

    public typealias Magnitude = Double
    public static var unit: Unit {
        return UnitSpecifyingType.unit
    }
    public let magnitude: Magnitude

    public init(valid magnitude: Magnitude) {
        self.magnitude = magnitude
    }
    
    public init(_ magnitude: Magnitude) {
        self.init(valid: magnitude)
    }

}
