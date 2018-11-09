//
//  Nonce.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Nonce {
    public let nonce: Int
    public init(_ nonce: Int = 0) {
        self.nonce = nonce
    }
}

extension Nonce: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
