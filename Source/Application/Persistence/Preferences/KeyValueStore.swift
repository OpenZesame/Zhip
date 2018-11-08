//
//  KeyValueStore.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// A type-erasing key-value store that wraps some type confirming to `KeyValueStoring`
struct KeyValueStore<KeyType>: KeyValueStoring where KeyType: KeyConvertible {
    typealias Key = KeyType

    private let _save: (Any, String) -> Void
    private let _load: (String) -> Any?
    private let _delete: (String) -> Void

    init<Concrete>(_ concrete: Concrete) where Concrete: KeyValueStoring, Concrete.Key == KeyType {
        _save = { concrete.save(value: $0, for: $1) }
        _load = { concrete.loadValue(for: $0) }
        _delete = { concrete.deleteValue(for: $0) }
    }
}

// MARK: - KeyValueStoring Methods
extension KeyValueStore {
    func save(value: Any, for key: String) {
        _save(value, key)
    }

    func loadValue(for key: String) -> Any? {
        return _load(key)
    }

    func deleteValue(for key: String) {
        _delete(key)
    }
}
