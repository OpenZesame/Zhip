//import KeychainSwift
import KeychainAccess
import Foundation
//
public final class KeychainManager: KeyValueStoring {
//    private let wrapped: KeychainSwift
    private let wrapped: Keychain

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    public static let `default` = KeychainManager()
    public init() {
        self.wrapped = Keychain(service: "com.openzesame.zhip")
            .label("Zhip")
            .synchronizable(false)
            .accessibility(.whenPasscodeSetThisDeviceOnly)
    }
}
//
//public extension KeychainManager {
//    func saveCodable<C: Codable>(_ model: C, for key: Key) throws {
//        let jsonData = try encoder.encode(model)
//        try save(data: jsonData, key: key)
//    }
//
//    func loadCodable<C: Codable>(for key: Key) throws -> C? {
//        try loadCodable(C.self, for: key)
//    }
//
//    func loadCodable<C: Codable>(_ modelType: C.Type, for key: Key) throws -> C? {
//        guard let jsonData = try loadData(key: key) else { return nil }
//        return try decoder.decode(C.self, from: jsonData)
//    }
//
//    func deleteValue(for key: Key) throws {
//        try wrapped.remove(key.id, ignoringAttributeSynchronizable: false)
//    }
//}
//
//private extension KeychainManager {
//
//    func loadData(key: Key) throws -> Data? {
//        try wrapped.getData(key.id, ignoringAttributeSynchronizable: false)
//    }
//
//    func save(data: Data, key: Key) throws {
//        try wrapped.set(data, key: key.id, ignoringAttributeSynchronizable: false)
//    }
//}


/// Key to senstive values being store in Keychain, e.g. the cryptograpically sensitive keystore file, containing an encryption of your wallets private key.
public enum KeychainKey: String, KeyConvertible {
    case keystore
    
    /// Might be sensitive how much Zillings a person owns.
    case cachedZillingBalance
    
    case pincodeProtectingAppThatHasNothingToDoWithCryptography
}

/// Abstraction of Keychain
public typealias SecurePersistence = KeyValueStore<KeychainKey>
public extension SecurePersistence {
    static let `default` = Self(KeychainManager.default)
}

public extension KeychainManager {
    typealias Key = KeychainKey
    
    func loadValue(for key: String) throws -> Any? {
        if let data = try wrapped.getData(key) {
            return data
        } else if let string: String = try wrapped.get(key) {
            if string == "false" {
                return false
            } else if string == "true" {
                return true
            } else {
                return string
            }
        } else {
            return nil
        }
    }

    /// Saves items in Keychain using access option `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`
    /// Do not that means that if the user unsets the iOS passcode for their iOS device, then all data
    /// will be lost, read more:
    /// https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly
    func save(value: Any, for key: String) throws {
//        let access: KeychainSwiftAccessOptions = .accessibleWhenPasscodeSetThisDeviceOnly
//        if let data = value as? Data {
//            set(data, forKey: key, withAccess: access)
//        } else if let bool = value as? Bool {
//            set(bool, forKey: key, withAccess: access)
//        } else if let string = value as? String {
//            set(string, forKey: key, withAccess: access)
//        }
        if let bool = value as? Bool {
            if bool {
                try wrapped.set("true", key: key)
            } else {
                try wrapped.set("false", key: key)
            }
        } else if let string = value as? String {
            try wrapped.set(string, key: key)
        } else if let data = value as? Data {
            try wrapped.set(data, key: key)
        } else {
            fatalError("cannot save value of type: \(type(of: value))")
        }
    }

    func deleteValue(for key: String) throws {
        try wrapped.remove(key)
    }
}


// MARK: - Wallet
public extension KeyValueStore where Key == KeychainKey {
    var wallet: Wallet? {
        // Delete wallet upon reinstall if needed. This makes sure that after a reinstall of the app, the flag
        // `hasRunAppBefore`, which recides in UserDefaults - which gets reset after uninstalls, will be false
        // thus we should not have any wallet configured. Delete previous one if needed and always return nil
        guard Preferences.default.isTrue(.hasRunAppBefore) else {
            try! Preferences.default.save(value: true, for: .hasRunAppBefore)
            deleteWallet()
            deletePincode()
            
            try! deleteValue(for: .cachedZillingBalance)
            
            try! Preferences.default.deleteValue(for: .balanceWasUpdatedAt)
            return nil
        }
        return try! loadCodable(Wallet.self, for: .keystore)
    }

    var hasConfiguredWallet: Bool {
        return wallet != nil
    }

    func save(wallet: Wallet) {
        try! saveCodable(wallet, for: .keystore)
    }

    func deleteWallet() {
        try! deleteValue(for: .keystore)
    }
}

public extension KeyValueStore where Key == KeychainKey {

    var pincode: Pincode? {
        try? loadCodable(Pincode.self, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    var hasConfiguredPincode: Bool {
        return pincode != nil
    }

    func save(pincode: Pincode) {
        try! saveCodable(pincode, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    func deletePincode() {
        try! deleteValue(for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }
}


public extension KeyValueStore where Key == PreferencesKey {
    static var `default`: Preferences {
        KeyValueStore(UserDefaults.standard)
    }
}


// MARK: - KeyValueStoring
extension UserDefaults: KeyValueStoring {}
    public extension UserDefaults {

    func deleteValue(for key: String) throws {
        removeObject(forKey: key)
    }

    typealias Key = PreferencesKey

    func save(value: Any, for key: String) throws {
        self.setValue(value, forKey: key)
    }

    func loadValue(for key: String) throws -> Any? {
        return value(forKey: key)
    }
}

