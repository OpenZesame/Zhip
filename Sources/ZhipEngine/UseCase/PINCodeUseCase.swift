//
//  PINCodeUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-23.
//

import Foundation
import Combine

// MARK: - PINCodeUseCase
// MARK: -
public protocol PINCodeUseCase: AnyObject {
    func userChoose(pincode: Pincode)
    func skipSettingUpPincode()
    func deletePincode()
    var pincodeSubject: CurrentValueSubject<Pincode?, Never> { get }
    var hasConfiguredPincode: Bool { get }
}

// MARK: - DefaultPINCodeUseCase
// MARK: -
public final class DefaultPINCodeUseCase: PINCodeUseCase {
    private let preferences: Preferences
    
    private let securePersistence: SecurePersistence
    
    public let pincodeSubject: CurrentValueSubject<Pincode?, Never>
    
    public init(preferences: Preferences, securePersistence: SecurePersistence) {
        self.preferences = preferences
        self.securePersistence = securePersistence
        self.pincodeSubject = CurrentValueSubject(securePersistence.pincode)
    }
}

// MARK: - PINCodeUseCase Conf.
// MARK: -
public extension DefaultPINCodeUseCase {

    func skipSettingUpPincode() {
        try! preferences.save(value: true, for: .skipPincodeSetup)
    }

    var hasConfiguredPincode: Bool {
        let hasConfiguredPincode = pincodeSubject.value != nil
        assert(securePersistence.hasConfiguredPincode == hasConfiguredPincode)
        return hasConfiguredPincode
    }

    func deletePincode() {
        try! preferences.deleteValue(for: .skipPincodeSetup)
        try! securePersistence.deleteValue(for: .pincodeProtectingAppThatHasNothingToDoWithCryptography)
        pincodeSubject.send(nil)
    }

    func userChoose(pincode: Pincode) {
        securePersistence.save(pincode: pincode)
        pincodeSubject.send(pincode)
    }
}
