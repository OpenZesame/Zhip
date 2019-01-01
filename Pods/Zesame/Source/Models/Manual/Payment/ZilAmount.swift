//
//  ZilAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct ZilAmount: ExpressibleByAmount, Upperbound, Lowerbound {

    public typealias Magnitude = Zil.Magnitude

    public static let unit: Unit = .zil

    public static let minInQa: Zil.Magnitude = 0
    public static let maxInQa: Zil.Magnitude = "21000000000000000000000"

    public let qa: Magnitude

    public init(qa: Magnitude) throws {
         self.qa = try ZilAmount.validate(value: qa)
    }
}
