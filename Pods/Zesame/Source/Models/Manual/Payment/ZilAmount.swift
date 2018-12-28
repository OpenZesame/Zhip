//
//  ZilAmount.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct ZilAmount: ExpressibleByAmount {
    public typealias Magnitude = Zil.Magnitude
    public static let minMagnitude = Zil.min
    public static let maxMagnitude = Zil.max
    public static let unit: Unit = .zil
    public let magnitude: Magnitude

    public init(magnitude: Magnitude) {
        self.magnitude = magnitude
    }
}
