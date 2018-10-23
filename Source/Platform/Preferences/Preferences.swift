//
//  Preferences.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

typealias Preferences = KeyValueStore<PreferencesKey>

protocol KeyConvertible {
    var key: String { get }
}

extension KeyConvertible where Self: RawRepresentable, Self.RawValue == String {
    var key: String { return rawValue }
}

protocol AnyKeyValueStoring {
    func save(value: Any, for key: String)
    func loadValue(for key: String) -> Any?
}

extension UserDefaults: KeyValueStoring {
    typealias Key = PreferencesKey

    func save(value: Any, for key: String) {
        self.setValue(value, forKey: key)
    }

    func loadValue(for key: String) -> Any? {
        return value(forKey: key)
    }
}

protocol KeyValueStoring: AnyKeyValueStoring {
    associatedtype Key: KeyConvertible
    func save<Value>(value: Value, for key: Key)
    func loadValue<Value>(for key: Key) -> Value?
}

extension KeyValueStoring {
    func isTrue(_ key: Key) -> Bool {
        guard let bool: Bool = loadValue(for: key) else { return false }
        return bool == true
    }
}

extension KeyValueStoring {
    func save<Value>(value: Value, for key: Key) {
        save(value: value, for: key.key)
    }
    func loadValue<Value>(for key: Key) -> Value? {
        guard let value = loadValue(for: key.key), let typed = value as? Value else { return nil }
        return typed
    }
}

struct KeyValueStore<KeyType>: KeyValueStoring where KeyType: KeyConvertible {
    typealias Key = KeyType

    private let _save: (Any, String) -> Void
    private let _load: (String) -> Any?

    init<Concrete>(_ concrete: Concrete) where Concrete: KeyValueStoring, Concrete.Key == KeyType {
        _save = { concrete.save(value: $0, for: $1) }
        _load = { concrete.loadValue(for: $0) }
    }

    func save(value: Any, for key: String) {
        _save(value, key)
    }

    func loadValue(for key: String) -> Any? {
        return _load(key)
    }
}

enum PreferencesKey: String, KeyConvertible {
    case hasAcceptedTermsOfService
    case skipShowingERC20Warning
}

enum KeychainKey: String, KeyConvertible {
    case keystoreEncryptionPassphrase
}
