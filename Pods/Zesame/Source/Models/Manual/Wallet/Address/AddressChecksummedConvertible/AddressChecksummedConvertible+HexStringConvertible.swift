//
//  AddressChecksummedConvertible+HexStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - HexStringConvertible
public extension AddressChecksummedConvertible {
    var hexString: HexString { return checksummedAddress.checksummed }
}
