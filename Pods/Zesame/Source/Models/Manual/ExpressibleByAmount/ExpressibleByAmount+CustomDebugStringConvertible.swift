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
        return "\(qa) qa (\(asString(in: .zil, roundingIfNeeded: nil)) Zils)"
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

    func asString(`in` targetUnit: Unit, roundingIfNeeded: NSDecimalNumber.RoundingMode? = nil, roundingNumberOfDigits: Int = 2, minFractionDigits: Int? = nil) -> String {
        // handle trivial edge case
        if targetUnit == .qa {
            return "\(qa)"
        }

        let decimal = decimalValue(in: targetUnit, rounding: roundingIfNeeded, roundingNumberOfDigits: roundingNumberOfDigits)
        let nsDecimalNumber = NSDecimalNumber(decimal: decimal)
        guard let decimalString = asStringUsingLocalizedDecimalSeparator(nsDecimalNumber: nsDecimalNumber, maxFractionDigits: 12, minFractionDigits: minFractionDigits) else {
            fatalError("should be able to create string")
        }
        return decimalString
    }
}
