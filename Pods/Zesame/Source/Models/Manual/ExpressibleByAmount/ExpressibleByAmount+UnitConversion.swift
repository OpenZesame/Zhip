//
//  ExpressibleByAmount+UnitConversion.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

// Unit conversion
public extension ExpressibleByAmount {
    func valueMeasured(in unit: Unit) -> Magnitude {
        return Self.express(magnitude, in: unit)
    }

    static func express(_ input: Magnitude, in unit: Unit) -> Magnitude {
        return Magnitude.init(floatLiteral: input / pow(10, Double(unit.exponent - Self.unit.exponent)))
    }

    var inZil: Zil {
        return Zil(magnitude: valueMeasured(in: .zil))
    }

    init(zil: Zil) throws {
        try self.init(zil.valueMeasured(in: Self.unit))
    }

    var inLi: Li {
        return Li(magnitude: valueMeasured(in: .li))
    }

    init(li: Li) throws {
        try self.init(li.valueMeasured(in: Self.unit))
    }

    var inQa: Qa {
        return Qa(magnitude: valueMeasured(in: .qa))
    }

    init(qa: Qa) throws {
        try self.init(qa.valueMeasured(in: Self.unit))
    }
}
