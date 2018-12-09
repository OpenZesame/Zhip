//
//  EncryptionPassphraseValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

struct EncryptionPassphraseValidator: InputValidator {
    typealias Input = String
    typealias Output = WalletEncryptionPassphrase
    typealias Error = WalletEncryptionPassphrase.Error

    private let mode: WalletEncryptionPassphrase.Mode
    init(mode: WalletEncryptionPassphrase.Mode) {
        self.mode = mode
    }

    func validate(input: Input) -> InputValidationResult<Output> {
        do {
            return .valid(try WalletEncryptionPassphrase(passphrase: input, confirm: input, mode: mode))
        } catch let passphraseError as Error {
            return .invalid(.error(message: passphraseError.errorMessage))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
}

extension WalletEncryptionPassphrase.Error: InputError {
    var errorMessage: String {
        let Message = L10n.Error.Input.Passphrase.self

        switch self {
        case .passphraseIsTooShort(let minLength): return Message.tooShort(minLength)
        case .passphrasesDoesNotMatch: incorrectImplementation("Should pass the same passphrase in `validate:input` method")
        }
    }
}
