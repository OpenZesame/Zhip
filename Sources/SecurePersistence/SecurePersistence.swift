//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-11.
//

import Foundation
import KeyValueStore
import KeychainManager

/// Abstraction of Keychain
public typealias SecurePersistence = KeyValueStore<KeychainKey>
public extension SecurePersistence {
	static let `default` = Self(KeychainManager.default)
}

extension RawRepresentable where RawValue == String {
    public typealias ID = RawValue
    public var id: ID { rawValue }
}
