//
//  Qa.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import BigInt

public struct Qa: ExpressibleByAmount, Unbound {

    public typealias Magnitude = BigInt
    public static let unit: Unit = .qa
    public let qa: Magnitude

    public init(qa: Magnitude) {
        self.qa = qa
    }
}
