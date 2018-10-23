//
//  Preferences.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import KeychainSwift

extension KeychainSwift: KeyValueStoring {
    typealias Key = KeychainKey

    func loadValue(for key: String) -> Any? {
        if let data = getData(key) {
            return data
        } else if let bool = getBool(key) {
            return bool
        } else if let string = get(key) {
            return string
        } else {
            return nil
        }
    }

    /// Saves items in Keychain using access option `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`
    /// Do not that means that if the user unsets the iOS passcode for their iOS device, then all data
    /// will be lost, read more:
    /// https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly
    func save(value: Any, for key: String) {
        let access: KeychainSwiftAccessOptions = .accessibleWhenPasscodeSetThisDeviceOnly
        if let data = value as? Data {
            set(data, forKey: key, withAccess: access)
        } else if let bool = value as? Bool {
            set(bool, forKey: key, withAccess: access)
        } else if let string = value as? String {
            set(string, forKey: key, withAccess: access)
        }
    }

    func deleteValue(for key: String) {
        delete(key)
    }
}

typealias Preferences = KeyValueStore<PreferencesKey>
typealias SecurePersistence = KeyValueStore<KeychainKey>

protocol KeyConvertible {
    var key: String { get }
}

extension KeyConvertible where Self: RawRepresentable, Self.RawValue == String {
    var key: String { return rawValue }
}

protocol AnyKeyValueStoring {
    func save(value: Any, for key: String)
    func loadValue(for key: String) -> Any?
    func deleteValue(for key: String)
}

extension UserDefaults: KeyValueStoring {

    func deleteValue(for key: String) {
        removeObject(forKey: key)
    }

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
    func deleteValue(for key: Key)
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

    func deleteValue(for key: Key) {
        deleteValue(for: key.key)
    }

}

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

enum PreferencesKey: String, KeyConvertible {
    case hasAcceptedTermsOfService
    case skipShowingERC20Warning
}

enum KeychainKey: String, KeyConvertible {
    case keystore
}

//protocol SecurePersistence {
//    func save<Value>(value: Value) where Value: Codable
//    func loadValue<Value>(value: Value) where Value: Codable
//}
//
//extension SecurePersistence {
//
//    func save(keystore: Keystore) {
//
//    }
//
//    func loadKeystore() -> Keystore {
//
//    }
//
//    func deleteKeystore() {
//
//    }
//
//    func save(wallet: Wallet) {
//        save(keystore: wallet.keystore)
//    }
//}

