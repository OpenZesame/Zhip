//
//  Wallet+CustomStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension Wallet: CustomStringConvertible {}
public extension Wallet {
    var description: String {
        return "Wallet(address: '\(address)')"
    }
}

