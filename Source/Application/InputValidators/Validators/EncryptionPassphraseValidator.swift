//
//  EncryptionPassphraseValidator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

struct EncryptionPassphraseValidator: InputValidator {
    typealias Input = (passphrase: String, confirmingPassphrase: String)
    typealias Output = WalletEncryptionPassphrase
    typealias Error = WalletEncryptionPassphrase.Error

    private let mode: WalletEncryptionPassphrase.Mode
    init(mode: WalletEncryptionPassphrase.Mode) {
        self.mode = mode
    }

    func validate(input: Input) -> Validation<Output, Error> {
        let passphrase = input.passphrase
        let confirmingPassphrase = input.confirmingPassphrase
        do {
            return .valid(try WalletEncryptionPassphrase(passphrase: passphrase, confirm: confirmingPassphrase, mode: mode))
        } catch let passphraseError as Error {
            return .invalid(.error(passphraseError))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
}

extension WalletEncryptionPassphrase.Error: InputError, Equatable {
    var errorMessage: String {
        let Message = L10n.Error.Input.Passphrase.self

        switch self {
        case .passphraseIsTooShort(let minLength): return Message.tooShort(minLength)
        case .passphrasesDoesNotMatch: return Message.confirmingPassphraseMismatch
        case .incorrectPassphrase(let backingUpWalletJustCreated):
            if backingUpWalletJustCreated {
                return Message.incorrectPassphraseDuringBackupOfNewlyCreatedWallet
            } else {
                return Message.incorrectPassphrase
            }
        }
    }

    static func == (lhs: WalletEncryptionPassphrase.Error, rhs: WalletEncryptionPassphrase.Error) -> Bool {
        switch (lhs, rhs) {
        case (.passphraseIsTooShort, passphraseIsTooShort): return true
        case (.passphrasesDoesNotMatch, passphrasesDoesNotMatch): return true
        case (.incorrectPassphrase, incorrectPassphrase): return true
        default: return false
        }
    }
}
