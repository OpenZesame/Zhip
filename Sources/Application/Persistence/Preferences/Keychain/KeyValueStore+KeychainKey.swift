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

import Foundation
import Zesame

// MARK: - Wallet
extension KeyValueStore where KeyType == KeychainKey {
    var wallet: Wallet? {
        // Delete wallet upon reinstall if needed. This makes sure that after a reinstall of the app, the flag
        // `hasRunAppBefore`, which recides in UserDefaults - which gets reset after uninstalls, will be false
        // thus we should not have any wallet configured. Delete previous one if needed and always return nil
        guard Preferences.default.isTrue(.hasRunAppBefore) else {
            Preferences.default.save(value: true, for: .hasRunAppBefore)
            deleteWallet()
            deletePincode()
            Preferences.default.deleteValue(for: .cachedBalance)
            Preferences.default.deleteValue(for: .balanceWasUpdatedAt)
            return nil
        }
        return loadCodable(Wallet.self, for: .keystore)
    }

    var hasConfiguredWallet: Bool {
        return wallet != nil
    }

    func save(wallet: Wallet) {
        saveCodable(wallet, for: .keystore)
    }

    func deleteWallet() {
        deleteValue(for: .keystore)
    }
}

extension KeyValueStore where KeyType == KeychainKey {

    var pincode: Pincode? {
        return loadCodable(Pincode.self, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    var hasConfiguredPincode: Bool {
        return pincode != nil
    }

    func save(pincode: Pincode) {
        saveCodable(pincode, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    func deletePincode() {
        deleteValue(for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }
}
