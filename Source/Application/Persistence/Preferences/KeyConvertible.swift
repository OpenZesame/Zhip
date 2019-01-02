//
//  KeyConvertible.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Type used as a key to some value, e.g. a wrapper around `UserDefaults`
protocol KeyConvertible {
    var key: String { get }
}

// MARK: - Default Implementation for `enum SomeKey: String`
extension KeyConvertible where Self: RawRepresentable, Self.RawValue == String {
    var key: String { return rawValue }
}
