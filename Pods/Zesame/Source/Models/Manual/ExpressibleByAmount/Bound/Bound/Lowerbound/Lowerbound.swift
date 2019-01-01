//
//  Lowerbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol Lowerbound: Bound {
    static var minInQa: Magnitude { get }
    static var min: Self { get }
    static func - (lhs: Self, rhs: Self) throws -> Self
}

extension Lowerbound where Self: ExpressibleByAmount {
    public static var min: Self {
        return try! Self(qa: minInQa)
    }
}
