//
//  ExpressibleByAmount+CustomDebugStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
