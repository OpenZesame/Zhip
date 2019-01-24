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

import Foundation
import Zesame

struct WalletEncryptionPassword {

    let validPassword: String
    
    init(password: String, confirm: String, mode: Mode) throws {
        let minLength = mode.mimimumPasswordLength
        guard confirm == password else { throw Error.passwordsDoesNotMatch }
        guard password.count >= minLength else { throw Error.passwordIsTooShort(mustAtLeastHaveLength: minLength) }
        validPassword = password
    }
}

extension WalletEncryptionPassword {
    static func minimumLenght(mode: Mode) -> Int {
        return mode.mimimumPasswordLength
    }

    static func modeFrom(wallet: Wallet) -> WalletEncryptionPassword.Mode {
        return wallet.passwordMode
    }

    static func minimumLengthForWallet(_ wallet: Wallet) -> Int {
        return minimumLenght(mode: wallet.passwordMode)
    }
}

// MARK: - Error
import Zesame
extension WalletEncryptionPassword {
    enum Error: Swift.Error {
        case passwordsDoesNotMatch
        case passwordIsTooShort(mustAtLeastHaveLength: Int)
        case incorrectPassword(backingUpWalletJustCreated: Bool)

        static func incorrectPasswordErrorFrom(walletImportError: Zesame.Error.WalletImport, backingUpWalletJustCreated: Bool = false) -> Error? {
            switch walletImportError {
            case .incorrectPassword: return .incorrectPassword(backingUpWalletJustCreated: backingUpWalletJustCreated)
            default: return nil
            }
        }

        static func incorrectPasswordErrorFrom(error: Swift.Error, backingUpWalletJustCreated: Bool = false) -> Error? {
			guard
				let zesameError = error as? Zesame.Error,
				case .walletImport(let walletImportError) = zesameError
				else { return nil }

            return incorrectPasswordErrorFrom(walletImportError: walletImportError, backingUpWalletJustCreated: backingUpWalletJustCreated)
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
    var mimimumPasswordLength: Int {
        switch self {
        case .newOrRestorePrivateKey: return 8
        case .restoreKeystore: return Zesame.Keystore.minumumPasswordLength
        }
    }
}

// MARK: Wallet.Origin -> Mode
private extension Wallet.Origin {
    var passwordMode: WalletEncryptionPassword.Mode {
        switch self {
        case .generatedByThisApp, .importedPrivateKey: return .newOrRestorePrivateKey
        case .importedKeystore: return .restoreKeystore
        }
    }
}

// MARK: Wallet -> Mode
private extension Wallet {
    var passwordMode: WalletEncryptionPassword.Mode {
        return origin.passwordMode
    }
}

extension WalletEncryptionPassword: Equatable {}
