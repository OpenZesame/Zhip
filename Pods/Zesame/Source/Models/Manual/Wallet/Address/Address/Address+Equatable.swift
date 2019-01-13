//
//  Address+Equatable.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - Equatable
extension Address: Equatable {}
public extension Address {
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.hexString == rhs.hexString
    }
}
