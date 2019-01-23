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
