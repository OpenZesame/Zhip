//
//  Address+AddressChecksummedConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: AddressChecksummedConvertible
public extension Address {
    init(hexString: HexStringConvertible) throws {
        if let checksummed = try? AddressChecksummed(hexString: hexString) {
            self = .checksummed(checksummed)
        } else {
            self = .notNecessarilyChecksummed(try AddressNotNecessarilyChecksummed(hexString: hexString))
        }
    }

    var checksummedAddress: AddressChecksummed {
        switch self {
        case .checksummed(let checksummed): return checksummed
        case .notNecessarilyChecksummed(let notNecessarilyChecksummed): return notNecessarilyChecksummed.checksummedAddress
        }
    }
}
