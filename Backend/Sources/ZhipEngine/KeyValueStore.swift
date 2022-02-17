//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation

/// A simple non thread safe, non async, key value store without associatedtypes
public protocol AnyKeyValueStoring {
    func save(value: Any, for key: String) throws
    func loadValue(for key: String) throws -> Any?
    func deleteValue(for key: String) throws
}


/// Type used as a key to some value, e.g. a wrapper around `UserDefaults`
public protocol KeyConvertible {
    var key: String { get }
}

// MARK: - Default Implementation for `enum SomeKey: String`
public extension KeyConvertible where Self: RawRepresentable, Self.RawValue == String {
    var key: String { return rawValue }
}

/// A type-erasing key-value store that wraps some type confirming to `KeyValueStoring`
public struct KeyValueStore<Key: KeyConvertible>: KeyValueStoring {

    private let _save: (Any, String) throws -> Void
    private let _load: (String) throws -> Any?
    private let _delete: (String) throws -> Void

    public init<Concrete>(_ concrete: Concrete) where Concrete: KeyValueStoring, Concrete.Key == Key {
        _save = { try concrete.save(value: $0, for: $1) }
        _load = { try concrete.loadValue(for: $0) }
        _delete = { try concrete.deleteValue(for: $0) }
    }
}

// MARK: - KeyValueStoring Methods
public extension KeyValueStore {
    func save(value: Any, for key: String) throws {
       try  _save(value, key)
    }

    func loadValue(for key: String) throws -> Any? {
        try _load(key)
    }

    func deleteValue(for key: String) throws {
        try _delete(key)
    }
}


/// A typed simple, non thread safe, non async key-value store accessing values using its associatedtype `Key`
public protocol KeyValueStoring: AnyKeyValueStoring {
    associatedtype Key: KeyConvertible
    func save<Value>(value: Value, for key: Key) throws
    func loadValue<Value>(for key: Key) throws -> Value?
    func deleteValue(for key: Key) throws
}

// MARK: Default Implementation making use of `AnyKeyValueStoring` protocol
public extension KeyValueStoring {

    func save<Value>(value: Value, for key: Key) throws {
        try save(value: value, for: key.key)
    }

    func loadValue<Value>(for key: Key) throws -> Value? {
        guard let value = try loadValue(for: key.key), let typed = value as? Value else { return nil }
        return typed
    }

    func deleteValue(for key: Key) throws {
        try deleteValue(for: key.key)
    }
}

// MARK: - Codable
public extension KeyValueStoring {
    func loadCodable<C>(_ modelType: C.Type, for key: Key) throws -> C? where C: Codable {
        guard
            let json: Data = try loadValue(for: key)
            else { return nil }
        return try JSONDecoder().decode(C.self, from: json)
    }
    
    func saveCodable<C>(_ model: C, for key: Key) throws where C: Codable {
        let encoder = JSONEncoder()
        let json = try encoder.encode(model)
        try save(value: json, for: key)
    }
}

// MARK: Convenience
public extension KeyValueStoring {
    func isTrue(_ key: Key) -> Bool {
        guard let bool: Bool = try? loadValue(for: key) else { return false }
        return bool == true
    }

    func isFalse(_ key: Key) -> Bool {
        return !isTrue(key)
    }
}


/// Insensitive values to be stored into e.g. `UserDefaults`, such as `hasAcceptedTermsOfService`
public enum PreferencesKey: String, KeyConvertible {
    case hasRunAppBefore
    case hasAcceptedTermsOfService
//    case hasAcceptedCustomECCWarning
//    case hasAnsweredCrashReportingQuestion
//    case hasAcceptedCrashReporting
    case skipPincodeSetup
    case cachedBalance
    case balanceWasUpdatedAt
}

/// Abstraction of UserDefaults
public typealias Preferences = KeyValueStore<PreferencesKey>