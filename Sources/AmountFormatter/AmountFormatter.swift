//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-25.
//

import Foundation
import Zesame
import Common

public extension Zesame.Unit {
    var displayName: String {
        let unitName: String
        switch self {
        case .li, .qa: unitName = self.name
        case .zil: unitName = "ZILs"
        }
        return unitName
    }
}

public struct AmountFormatter {
    public init() {}
}

public extension AmountFormatter {
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
