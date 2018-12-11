//
//  Nonce.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public struct Nonce {
    public let nonce: UInt64
    public init(_ nonce: UInt64 = 0) {
        self.nonce = nonce
    }
}

public extension Nonce {
    func increasedByOne() -> Nonce {
        return Nonce(nonce + 1)
    }
}

extension Nonce: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        let nonce = UInt64(value)
        self.init(nonce)
    }
}

extension Nonce: Equatable {}
