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
import Zesame

extension Zesame.Unit {
    var displayName: String {
        let unitName: String
        switch self {
        case .li, .qa: unitName = self.name
        case .zil: unitName = L10n.Generic.zils
        }
        return unitName
    }
}

struct AmountFormatter {
    func format<Amount>(amount: Amount, in unit: Zesame.Unit, formatThousands: Bool, minFractionDigits: Int? = nil, showUnit: Bool = false) -> String where Amount: ExpressibleByAmount {
        let amountString = amount.formatted(unit: unit, formatThousands: formatThousands, minFractionDigits: minFractionDigits)
        guard showUnit else {
            return amountString
        }

        return "\(amountString) \(unit.displayName)"
    }
    
    /// Because we display default tx fee of 1000 li, which is 0.001 zil, so good to show one more digit than that => 5
    static let maxNumberOfDecimalDigits = 5
}

extension ExpressibleByAmount {
    func formatted(unit targetUnit: Zesame.Unit, formatThousands: Bool = false, minFractionDigits: Int? = nil) -> String {
        let string = asString(in: targetUnit, roundingIfNeeded: .down, roundingNumberOfDigits: AmountFormatter.maxNumberOfDecimalDigits, minFractionDigits: minFractionDigits)
        guard formatThousands else {
            return string
        }
        let decimalSeparator = Locale.current.decimalSeparatorForSure
        let components = string.components(separatedBy: decimalSeparator)
        if components.count == 2 {
            let integerPart = components[0]
            let decimalPart = components[1]
            return "\(integerPart.thousands)\(decimalSeparator)\(decimalPart)"
        } else if components.count == 1 {
            return string.thousands
        } else {
            incorrectImplementation("Got components.count: \(components.count)")
        }
    }
}

extension String {
    var thousands: String {
        let thousandsInserted = inserting(string: " ", every: 3)
        if thousandsInserted.hasSuffix(" ") {
            let trailingSpaceRemoved = String(thousandsInserted.dropLast())
            return trailingSpaceRemoved
        } else {
            return thousandsInserted
        }
    }
    
    func containsOnlyDecimalNumbers() -> Bool {
        guard CharacterSet(charactersIn: self).isSubset(of: CharacterSet.decimalDigits) else {
            return false
        }
        return true
    }
}
