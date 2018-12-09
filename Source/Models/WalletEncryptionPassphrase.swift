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

    let validPassphrase: String
    
    init(passphrase: String, confirm: String, mode: Mode) throws {
        let minLength = mode.mimimumPassphraseLength
        guard confirm == passphrase else { throw Error.passphrasesDoesNotMatch }
        guard passphrase.count >= minLength else { throw Error.passphraseIsTooShort(mustAtLeastHaveLength: minLength) }
        validPassphrase = passphrase
    }

    init(passphrase: String) {
        guard passphrase.count >= WalletEncryptionPassphrase.minimumLenght else { incorrectImplementation("should have validated passphrase earlier") }
        self.validPassphrase = passphrase
    }
}

extension WalletEncryptionPassphrase {
    static func minimumLenght(mode: Mode) -> Int {
        return mode.mimimumPassphraseLength
    }

    static func modeFrom(wallet: Wallet) -> WalletEncryptionPassphrase.Mode {
        return wallet.passphraseMode
    }

    static func minimumLengthForWallet(_ wallet: Wallet) -> Int {
        return minimumLenght(mode: wallet.passphraseMode)
    }

    static var minimumLenght: Int {
        let lengths = Mode.allCases.map { minimumLenght(mode: $0) }
        return lengths.min() ?? lengths[0]
    }
}

// MARK: - Error
extension WalletEncryptionPassphrase {
    enum Error: Swift.Error {
        case passphrasesDoesNotMatch
        case passphraseIsTooShort(mustAtLeastHaveLength: Int)
    }
}

// MARK: - Mode
extension WalletEncryptionPassphrase {
    enum Mode: CaseIterable {
        case new
        case restore
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

// MARK: Wallet.Origin -> Mode
private extension Wallet.Origin {
    var passphraseMode: WalletEncryptionPassphrase.Mode {
        switch self {
        case .generatedByThisApp: return .new
        case .imported: return .restore
        }
    }
}

// MARK: Wallet -> Mode
private extension Wallet {
    var passphraseMode: WalletEncryptionPassphrase.Mode {
        return origin.passphraseMode
    }
}
