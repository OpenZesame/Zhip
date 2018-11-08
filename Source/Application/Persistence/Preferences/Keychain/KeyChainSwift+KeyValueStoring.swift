//
//  KeyChainSwift+KeyValueStoring.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
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
