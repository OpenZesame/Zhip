//
//  UnitSpecifying.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol UnitSpecifying {
    static var unit: Unit { get }
}

// MARK: - Convenience
public extension UnitSpecifying {
    var unit: Unit { return Self.unit }

    static var powerOf: String {
        return unit.powerOf
    }
}
