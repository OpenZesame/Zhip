//
//  ExpressibleByAmount+UnitConversion.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

internal extension ExpressibleByAmount {
    static func toQa(magnitude: Magnitude) -> Magnitude {
        let exponentDiff = abs(Unit.qa.exponent - Self.unit.exponent)
        let powerFactor = BigNumber(10).power(exponentDiff)
        return magnitude * powerFactor
    }

    static func toQa(double: Double) -> Magnitude {
        return express(double: double, in: .qa)
    }
}

internal extension Double {
    var isInteger: Bool {
        return floor(self) == ceil(self)
    }
}

internal extension ExpressibleByAmount {
    func decimalValue(in targetUnit: Unit, rounding: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double? {
        guard targetUnit.exponent >= self.unit.exponent else {
            return nil
        }

        guard qa <= BigInt(Double.greatestFiniteMagnitude) else {
            return nil
        }

        let qaFittingInDouble = Double(qa)

        guard qaFittingInDouble.isInteger else {
            return nil
        }

        let exponentDiff = abs(Qa.unit.exponent - targetUnit.exponent)
        let powerFactor = pow(10, Double(exponentDiff))

        var decimalValueInTargetUnit = qaFittingInDouble / powerFactor

        // Only round when for UnitX -> UnitX decimal value representation, i.e. ZilAmount(0.51) expressed in Zil rounds to 1.0
        let shouldPerformRounding = targetUnit.exponent == self.unit.exponent

        if shouldPerformRounding {
            decimalValueInTargetUnit.round(rounding)
        }

        return decimalValueInTargetUnit
    }
}

// Unit conversion
public extension ExpressibleByAmount {

    static func express(double: Double, in targetUnit: Unit) -> Magnitude {
        let exponentDiff = abs(targetUnit.exponent - self.unit.exponent)
        let powerFactor = pow(10, Double(exponentDiff))
        // Instead of doing input / pow(10, Double(unit.exponent - Self.unit.exponent))
        // which may result in precision loss we perform either division or multiplication
        let value: Double
        if targetUnit.exponent > self.unit.exponent {
            value = double / powerFactor
            assert(value.isInteger, "should be integer")
        } else {
            value = double * powerFactor
        }
        return Magnitude(value)
    }

    var asZil: Zil {
        return Zil(qa: qa)
    }

    var asLi: Li {
        return Li(qa: qa)
    }

    var asQa: Qa {
        return Qa(qa: qa)
    }
}
