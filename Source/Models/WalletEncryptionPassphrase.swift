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
}

// MARK: - Error
import Zesame
extension WalletEncryptionPassphrase {
    enum Error: Swift.Error {
        case passphrasesDoesNotMatch
        case passphraseIsTooShort(mustAtLeastHaveLength: Int)
        case incorrectPassphrase(backingUpWalletJustCreated: Bool)

        static func incorrectPassphraseErrorFrom(walletImportError: Zesame.Error.WalletImport, backingUpWalletJustCreated: Bool = false) -> Error? {
            switch walletImportError {
            case .incorrectPasshrase: return .incorrectPassphrase(backingUpWalletJustCreated: backingUpWalletJustCreated)
            default: return nil
            }
        }

        static func incorrectPassphraseErrorFrom(error: Swift.Error, backingUpWalletJustCreated: Bool = false) -> Error? {
			guard
				let zesameError = error as? Zesame.Error,
				case .walletImport(let walletImportError) = zesameError
				else { return nil }

            return incorrectPassphraseErrorFrom(walletImportError: walletImportError, backingUpWalletJustCreated: backingUpWalletJustCreated)
        }
    }
}

// MARK: - Mode
extension WalletEncryptionPassphrase {
    enum Mode: CaseIterable {
        case newOrRestorePrivateKey
        case restoreKeystore
    }
}

extension WalletEncryptionPassphrase.Mode {
    var mimimumPassphraseLength: Int {
        switch self {
        case .newOrRestorePrivateKey: return 8
        case .restoreKeystore: return Zesame.Keystore.minumumPasshraseLength
        }
    }
}

// MARK: Wallet.Origin -> Mode
private extension Wallet.Origin {
    var passphraseMode: WalletEncryptionPassphrase.Mode {
        switch self {
        case .generatedByThisApp, .importedPrivateKey: return .newOrRestorePrivateKey
        case .importedKeystore: return .restoreKeystore
        }
    }
}

// MARK: Wallet -> Mode
private extension Wallet {
    var passphraseMode: WalletEncryptionPassphrase.Mode {
        return origin.passphraseMode
    }
}

extension WalletEncryptionPassphrase: Equatable {}
