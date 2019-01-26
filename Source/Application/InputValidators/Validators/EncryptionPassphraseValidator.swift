// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
