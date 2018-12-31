//
//  Unit.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public enum Unit: Int {
    case zil = 0
    case li = -6
    case qa = -12
}

public extension Unit {
    var exponent: Int {
        return rawValue
    }

    var powerOf: String {
        return "10^\(exponent)"
    }

    var name: String {
        switch self {
        case .zil: return "zil"
        case .li: return "li"
        case .qa: return "qa"
        }
    }
}

extension Unit: CustomStringConvertible {
    public var description: String {
        return name
    }
}

extension Unit: Comparable {
    public static func < (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.exponent < rhs.exponent
    }
}
