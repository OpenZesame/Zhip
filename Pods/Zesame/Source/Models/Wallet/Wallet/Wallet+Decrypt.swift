//
//  Wallet+Decrypt.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-10-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public extension Wallet {
    func decrypt(passphrase: String, done: @escaping Done<KeyPair>) {
        keystore.toKeypair(encryptedBy: passphrase, done: done)
    }
}
