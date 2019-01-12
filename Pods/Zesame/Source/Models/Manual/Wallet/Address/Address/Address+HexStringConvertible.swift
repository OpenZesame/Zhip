//
//  Address+HexStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - HexStringConvertible
public extension Address {
    var hexString: HexString {
        switch self {
        case .checksummed(let checksummed): return checksummed.hexString
        case .notNecessarilyChecksummed(let maybeChecksummed): return maybeChecksummed.hexString
        }
    }
}
