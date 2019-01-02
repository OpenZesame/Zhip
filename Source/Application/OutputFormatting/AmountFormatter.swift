//
//  AmountFormatter.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-02.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct AmountFormatter {
    func format<Amount>(amount: Amount, in unit: Zesame.Unit, showUnit: Bool = false) -> String where Amount: ExpressibleByAmount {
        let amountString = amount.formatted(unit: unit)
        guard showUnit else {
            return amountString
        }

        let unitName: String
        switch unit {
        case .li, .qa: unitName = unit.name
        case .zil: unitName = L10n.Generic.zils
        }

        return "\(amountString) \(unitName)"
    }
}

extension ExpressibleByAmount {
    func formatted(unit targetUnit: Zesame.Unit) -> String {
        return asString(in: targetUnit).thousands
    }
}

extension String {
    var thousands: String {
        return inserting(string: " ", every: 3)
    }
}
