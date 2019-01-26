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

extension Double {
    var asStringWithoutTrailingZeros: String {
        var formatted = String(describing: NSNumber(value: self).decimalValue)
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        guard formatted.contains(decimalSeparator) else {
            return formatted
        }
        while formatted.last == "0" {
            formatted = String(formatted.dropLast())
        }

        if String(formatted.last!) == decimalSeparator {
            formatted = String(formatted.dropLast())
        }

        return formatted
    }
}

public extension ExpressibleByAmount {
    var debugDescription: String {
        return "\(qa) qa (\(zilString) Zils)"
    }

    var zilString: String {
        return asString(in: .zil)
    }

    var liString: String {
        return asString(in: .li)
    }

    var qaString: String {
        return qa.asDecimalString()
    }

    func asString(`in` targetUnit: Unit, roundingIfNeeded: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> String {
        // handle trivial edge case
        if qa == 0 {
            return "0"
        }

        if let qaAsDecimal = decimalValue(in: targetUnit, rounding: roundingIfNeeded) {
            return qaAsDecimal.asStringWithoutTrailingZeros
        } else {
            let numberOfCharactersToDrop = abs(Unit.qa.exponent - targetUnit.exponent)
            let qaDecimalString = qa.asDecimalString()
            let string = String(qaDecimalString.dropLast(numberOfCharactersToDrop))
            return string
        }
    }
}
