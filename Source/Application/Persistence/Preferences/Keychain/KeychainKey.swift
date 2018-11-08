//
//  KeychainKey.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Key to senstive values being store in Keychain, e.g. the cryptograpically sensitive keystore file, containing an encryption of your wallets private key.
enum KeychainKey: String, KeyConvertible {
    case keystore
}

/// Abstraction of Keychain
typealias SecurePersistence = KeyValueStore<KeychainKey>
