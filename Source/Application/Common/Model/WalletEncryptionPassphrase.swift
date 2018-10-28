//
//  WalletEncryptionPassphrase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

struct WalletEncryptionPassphrase {
    enum Error: Swift.Error {
        case passphrasesDoesNotMatch
        case passphraseIsTooShort
    }
    static var minimumLength: Int {
        guard isDebug == false else { return 3 }
        return 8
    }
    let validPassphrase: String
    init(passphrase: String, confirm: String) throws {
        guard confirm == passphrase else { throw Error.passphrasesDoesNotMatch }
        guard passphrase.count >= WalletEncryptionPassphrase.minimumLength else { throw Error.passphraseIsTooShort }
        validPassphrase = passphrase
    }
}
