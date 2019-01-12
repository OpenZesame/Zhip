//
//  HexStringConvertible.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public protocol HexStringConvertible {
    var hexString: HexString { get }
}

// MARK: - Convenience
public extension HexStringConvertible {
    var asString: String {
        return hexString.value
    }

    var length: Int {
        return hexString.length
    }
}

// We dont want to mark `AddressConvertible` as `Equatable` since that puts "`Self` requirements" on it.
public func == (lhs: HexStringConvertible, rhs: HexStringConvertible) -> Bool {
    return lhs.asString == rhs.asString
}
