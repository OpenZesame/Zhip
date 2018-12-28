//
//  ExpressibleByAmount+MinMax.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// Min / Max
public extension ExpressibleByAmount {

    static var maxMagnitude: Magnitude {
        return Zil.express(Zil.Magnitude(floatLiteral: 21_000_000_000), in: Self.unit)
    }

    static var minMagnitude: Magnitude { return 0 }
    static var min: Self { return Self(magnitude: minMagnitude) }

    static var max: Self { return Self(magnitude: maxMagnitude) }
}
