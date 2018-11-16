//
//  DefaultPincodeUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
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

    func doesPincodeMatchChosen(_ pincode: Pincode) -> Bool {
        if let chosenPincode = securePersistence.loadCodable(Pincode.self, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography) {
            return pincode == chosenPincode
        } else {
            return false
        }
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
