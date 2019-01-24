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

struct EncryptionPasswordValidator: InputValidator {
    typealias Input = (password: String, confirmingPassword: String)
    typealias Output = WalletEncryptionPassword
    typealias Error = WalletEncryptionPassword.Error

    private let mode: WalletEncryptionPassword.Mode
    init(mode: WalletEncryptionPassword.Mode) {
        self.mode = mode
    }

    func validate(input: Input) -> Validation<Output, Error> {
        let password = input.password
        let confirmingPassword = input.confirmingPassword
        do {
            return .valid(try WalletEncryptionPassword(password: password, confirm: confirmingPassword, mode: mode))
        } catch let passwordError as Error {
            return .invalid(.error(passwordError))
        } catch {
            incorrectImplementation("Address.Error should cover all errors")
        }
    }
}

extension WalletEncryptionPassword.Error: InputError, Equatable {
    var errorMessage: String {
        let Message = L10n.Error.Input.Password.self

        switch self {
        case .passwordIsTooShort(let minLength): return Message.tooShort(minLength)
        case .passwordsDoesNotMatch: return Message.confirmingPasswordMismatch
        case .incorrectPassword(let backingUpWalletJustCreated):
            if backingUpWalletJustCreated {
                return Message.incorrectPasswordDuringBackupOfNewlyCreatedWallet
            } else {
                return Message.incorrectPassword
            }
        }
    }

    static func == (lhs: WalletEncryptionPassword.Error, rhs: WalletEncryptionPassword.Error) -> Bool {
        switch (lhs, rhs) {
        case (.passwordIsTooShort, passwordIsTooShort): return true
        case (.passwordsDoesNotMatch, passwordsDoesNotMatch): return true
        case (.incorrectPassword, incorrectPassword): return true
        default: return false
        }
    }
}
