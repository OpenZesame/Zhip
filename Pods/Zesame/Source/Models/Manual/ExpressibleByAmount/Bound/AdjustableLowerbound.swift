//
//  AdjustableLowerbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol AdjustableLowerbound: Lowerbound {
    static var minMagnitudeDefault: Magnitude { get }
    static var minMagnitude: Magnitude { get set }
    static func restoreDefaultMin()
}

public extension AdjustableLowerbound {
    static func restoreDefaultMin() {
        minMagnitude = minMagnitudeDefault
    }
}
