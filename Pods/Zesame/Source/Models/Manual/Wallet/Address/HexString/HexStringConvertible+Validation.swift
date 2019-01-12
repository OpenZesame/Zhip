//
//  HexStringConvertible+Validation.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public extension HexStringConvertible {
    var isValidAddressButNotNecessarilyChecksummed: Bool {
        do {
            try AddressNotNecessarilyChecksummed.validate(hexString: self)
            // passed validation
            return true
        } catch {
            return false
        }
    }
}
