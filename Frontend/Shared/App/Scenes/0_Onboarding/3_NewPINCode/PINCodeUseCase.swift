//
//  PINCodeUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation
import ZhipEngine

// MARK: - PINCodeUseCase
// MARK: -
public protocol PINCodeUseCase: AnyObject {
    func userChoose(pincode: Pincode)
    func skipSettingUpPincode()
    func deletePincode()
    var pincode: Pincode? { get }
    var hasConfiguredPincode: Bool { get }
}

// MARK: - DefaultPINCodeUseCase
// MARK: -
public final class DefaultPINCodeUseCase: PINCodeUseCase {
    private let preferences: Preferences
    
    private let securePersistence: SecurePersistence
    
    public init(preferences: Preferences, securePersistence: SecurePersistence) {
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

// MARK: - PINCodeUseCase Conf.
// MARK: -
public extension DefaultPINCodeUseCase {

    func skipSettingUpPincode() {
        try! preferences.save(value: true, for: .skipPincodeSetup)
    }

    var pincode: Pincode? {
        try! securePersistence.loadCodable(Pincode.self, for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    var hasConfiguredPincode: Bool {
        securePersistence.hasConfiguredPincode
    }

    func deletePincode() {
        try! preferences.deleteValue(for: .skipPincodeSetup)
        try! securePersistence.deleteValue(for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
    }

    func userChoose(pincode: Pincode) {
        securePersistence.save(pincode: pincode)
    }
}
