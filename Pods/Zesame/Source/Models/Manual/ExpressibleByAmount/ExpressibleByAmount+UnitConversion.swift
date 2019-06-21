// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
    func decimalValue(in targetUnit: Unit, rounding: NSDecimalNumber.RoundingMode?, roundingNumberOfDigits: Int = 2) -> Decimal {
        guard qa <= BigInt(Double.greatestFiniteMagnitude) else {
            fatalError("Too big amount")
        }
        let qaFittingInDecimal = Decimal(string: "\(qa)", locale: Locale.current)!

        let exponentDiff = Qa.unit.exponent - targetUnit.exponent
        
        var decimalValueInTargetUnit: Decimal
        if exponentDiff > 0 {
            let factor = pow(10, Double(exponentDiff))
            decimalValueInTargetUnit = qaFittingInDecimal * Decimal(factor)
        } else if exponentDiff < 0 {
            let denominator = pow(10, Double(abs(exponentDiff)))
            decimalValueInTargetUnit = qaFittingInDecimal / Decimal(denominator)
        } else if exponentDiff == 0 {
            decimalValueInTargetUnit = qaFittingInDecimal
        } else { fatalError("forgot case?") }
        
        // Only round when for UnitX -> UnitX decimal value representation, i.e. ZilAmount(0.51) expressed in Zil rounds to 1.0
        let tryToPerformRounding = targetUnit.exponent == self.unit.exponent
        
        if tryToPerformRounding, let rounding = rounding {
            var rounded = Decimal()
            NSDecimalRound(&rounded, &decimalValueInTargetUnit, roundingNumberOfDigits, rounding)
            decimalValueInTargetUnit = rounded
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
