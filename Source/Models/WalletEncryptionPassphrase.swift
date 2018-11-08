//
//  WalletEncryptionPassphrase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-28.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

struct WalletEncryptionPassphrase {
    enum Error: Swift.Error {
        case passphrasesDoesNotMatch
        case passphraseIsTooShort
    }

    enum Mode {
        case new
        case restore
    }

    let validPassphrase: String
    init(passphrase: String, confirm: String, mode: Mode) throws {
        let minLength = mode.mimimumPassphraseLength
        guard confirm == passphrase else { throw Error.passphrasesDoesNotMatch }
        guard passphrase.count >= minLength else { throw Error.passphraseIsTooShort }
        validPassphrase = passphrase
    }
}

extension WalletEncryptionPassphrase {
    static func minimumLenght(mode: Mode) -> Int {
        return mode.mimimumPassphraseLength
    }
}

extension WalletEncryptionPassphrase.Mode {
    var mimimumPassphraseLength: Int {
        switch self {
        case .new: return 8
        case .restore: return Zesame.Keystore.minumumPasshraseLength
        }
    }
}
