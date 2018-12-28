//
//  ExpressibleByAmount+CustomDebugStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension ExpressibleByAmount {
    var debugDescription: String {
        return "\(description) (value in zil: \(valueMeasured(in: .zil)))"
    }
}
