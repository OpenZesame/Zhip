//
//  Address+CustomStringConvertible.swift
//  Zesame-iOS
//
//  Created by Alexander Cyon on 2018-10-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension AddressNotNecessarilyChecksummed: CustomStringConvertible {}
public extension AddressNotNecessarilyChecksummed {
    var description: String {
        return hexString.description
    }
}
