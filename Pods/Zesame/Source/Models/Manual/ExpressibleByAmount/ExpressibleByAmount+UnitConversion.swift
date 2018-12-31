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
        let exponentDiff = abs(unit.exponent - self.unit.exponent)
        let powerFactor = pow(10, Double(exponentDiff))
        // Instead of doing input / pow(10, Double(unit.exponent - Self.unit.exponent))
        // which may result in precision loss we perform either division or multiplication
        if unit > self.unit {
            return input / powerFactor
        } else {
            return input * powerFactor
        }
    }

    var inZil: Zil {
        return Zil(valid: valueMeasured(in: .zil))
    }

    var inLi: Li {
        return Li(valid: valueMeasured(in: .li))
    }

    var inQa: Qa {
        return Qa(valid: valueMeasured(in: .qa))
    }
}

public extension ExpressibleByAmount {
    func `as`<E>(_ type: E.Type) -> E where E: ExpressibleByAmount {
        return E.init(valid: valueMeasured(in: E.unit))
    }

    func `as`<U>(_ type: U.Type) -> U where U: Unbound & ExpressibleByAmount {
        return U.init(valueMeasured(in: U.unit))
    }

    func `as`<B>(_ type: B.Type) throws -> B where B: Bound & ExpressibleByAmount {
        return try B.init(valueMeasured(in: B.unit))
    }
}
