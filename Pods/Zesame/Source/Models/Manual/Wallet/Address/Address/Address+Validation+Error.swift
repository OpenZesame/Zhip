//
//  Address+Validation+Error.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - Validation
public extension Address {
    public enum Error: Swift.Error {
        case tooLong
        case tooShort
        case notHexadecimal
        case notChecksummed
    }
}

// MARK: - Convenience getters
public extension Address {
    var isChecksummed: Bool {
        switch self {
        case .checksummed: return true
        case .notNecessarilyChecksummed(let maybeChecksummed):
            return AddressChecksummed.isChecksummed(hexString: maybeChecksummed)
        }
    }
}
