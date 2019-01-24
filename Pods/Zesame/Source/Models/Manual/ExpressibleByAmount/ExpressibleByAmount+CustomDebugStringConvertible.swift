//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
