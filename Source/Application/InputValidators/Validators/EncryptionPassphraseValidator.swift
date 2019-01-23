//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
