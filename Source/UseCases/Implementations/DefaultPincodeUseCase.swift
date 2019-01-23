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

final class DefaultPincodeUseCase {
    private let preferences: Preferences
    let securePersistence: SecurePersistence
    init(preferences: Preferences, securePersistence: SecurePersistence) {
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

extension DefaultPincodeUseCase: PincodeUseCase {

    func skipSettingUpPincode() {
        preferences.save(value: true, for: .skipPincodeSetup)
    }

    var pincode: Pincode? {
        return securePersistence.loadCodable(Pincode.self, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    var hasConfiguredPincode: Bool {
        return securePersistence.hasConfiguredPincode
    }

    func deletePincode() {
        preferences.deleteValue(for: .skipPincodeSetup)
        securePersistence.deleteValue(for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    func userChoose(pincode: Pincode) {
        securePersistence.save(pincode: pincode)
    }
}
