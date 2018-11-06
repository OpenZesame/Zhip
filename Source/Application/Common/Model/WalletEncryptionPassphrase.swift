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

    enum Mode: Int {
        case new = 8
        case restore = 2
    }

    static func minimumLenght(mode: Mode) -> Int {
        return mode.rawValue
    }

    let validPassphrase: String
    init(passphrase: String, confirm: String, mode: Mode) throws {
        let minLength = mode.rawValue
        guard confirm == passphrase else { throw Error.passphrasesDoesNotMatch }
        guard passphrase.count >= minLength else { throw Error.passphraseIsTooShort }
        validPassphrase = passphrase
    }
}
