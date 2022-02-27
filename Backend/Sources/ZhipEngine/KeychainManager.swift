import KeychainAccess
import Foundation

public final class KeychainManager: KeyValueStoring {
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
            DefaultUseCaseProvider.shared.nuke()
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

