//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
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

import Foundation
import Zesame

struct WalletEncryptionPassword {
    let validPassword: String

    init(password: String, confirm: String, mode: Mode) throws {
        let minLength = mode.minimumPasswordLength
        guard confirm == password else { throw Error.passwordsDoesNotMatch }
        guard password.count >= minLength else { throw Error.passwordIsTooShort(mustAtLeastHaveLength: minLength) }
        validPassword = password
    }
}

extension WalletEncryptionPassword {
    static func minimumLength(mode: Mode) -> Int {
        mode.minimumPasswordLength
    }

    static func modeFrom(wallet: Wallet) -> WalletEncryptionPassword.Mode {
        wallet.passwordMode
    }

    static func minimumLengthForWallet(_ wallet: Wallet) -> Int {
        minimumLength(mode: wallet.passwordMode)
    }
}

// MARK: - Error

extension WalletEncryptionPassword {
    enum Error: Swift.Error {
        case passwordsDoesNotMatch
        case passwordIsTooShort(mustAtLeastHaveLength: Int)
        case incorrectPassword(backingUpWalletJustCreated: Bool)

        static func incorrectPasswordErrorFrom(
            walletImportError: Zesame.Error.WalletImport,
            backingUpWalletJustCreated: Bool = false
        ) -> Error? {
            switch walletImportError {
            case .incorrectPassword: .incorrectPassword(backingUpWalletJustCreated: backingUpWalletJustCreated)
            default: nil
            }
        }

        static func incorrectPasswordErrorFrom(error: Swift.Error, backingUpWalletJustCreated: Bool = false) -> Error? {
            guard
                let zesameError = error as? Zesame.Error,
                case let .walletImport(walletImportError) = zesameError
            else { return nil }

            return incorrectPasswordErrorFrom(
                walletImportError: walletImportError,
                backingUpWalletJustCreated: backingUpWalletJustCreated
            )
        }
    }
}

// MARK: - Mode

extension WalletEncryptionPassword {
    enum Mode: CaseIterable {
        case newOrRestorePrivateKey
        case restoreKeystore
    }
}

extension WalletEncryptionPassword.Mode {
    var minimumPasswordLength: Int {
        switch self {
        case .newOrRestorePrivateKey: 8
        case .restoreKeystore: Zesame.Keystore.minimumPasswordLength
        }
    }
}

// MARK: Wallet.Origin -> Mode

private extension Wallet.Origin {
    var passwordMode: WalletEncryptionPassword.Mode {
        switch self {
        case .generatedByThisApp, .importedPrivateKey: .newOrRestorePrivateKey
        case .importedKeystore: .restoreKeystore
        }
    }
}

// MARK: Wallet -> Mode

private extension Wallet {
    var passwordMode: WalletEncryptionPassword.Mode {
        origin.passwordMode
    }
}

extension WalletEncryptionPassword: Equatable {}
