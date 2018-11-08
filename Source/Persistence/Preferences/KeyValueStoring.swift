//
//  KeyValueStoring.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// A typed simple, non thread safe, non async key-value store accessing values using its associatedtype `Key`
protocol KeyValueStoring: AnyKeyValueStoring {
    associatedtype Key: KeyConvertible
    func save<Value>(value: Value, for key: Key)
    func loadValue<Value>(for key: Key) -> Value?
    func deleteValue(for key: Key)
}

// MARK: Default Implementation making use of `AnyKeyValueStoring` protocol
extension KeyValueStoring {

    func save<Value>(value: Value, for key: Key) {
        save(value: value, for: key.key)
    }

    func loadValue<Value>(for key: Key) -> Value? {
        guard let value = loadValue(for: key.key), let typed = value as? Value else { return nil }
        return typed
    }

    func deleteValue(for key: Key) {
        deleteValue(for: key.key)
    }
}

// MARK: Convenience
extension KeyValueStoring {
    func isTrue(_ key: Key) -> Bool {
        guard let bool: Bool = loadValue(for: key) else { return false }
        return bool == true
    }
}
