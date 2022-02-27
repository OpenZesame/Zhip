//
//  OnboardingUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation

public protocol OnboardingUseCase: AnyObject {

    var hasAcceptedTermsOfService: Bool { get }
    func didAcceptTermsOfService()

    var shouldPromptUserToChosePincode: Bool { get }
}


public final class DefaultOnboardingUseCase: OnboardingUseCase {
    private let preferences: Preferences
    let securePersistence: SecurePersistence
    public init(preferences: Preferences, securePersistence: SecurePersistence) {
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

public extension DefaultOnboardingUseCase {
    var hasAcceptedTermsOfService: Bool {
        preferences.isTrue(.hasAcceptedTermsOfService)
    }

    func didAcceptTermsOfService() {
        try! preferences.save(value: true, for: .hasAcceptedTermsOfService)
    }

    var shouldPromptUserToChosePincode: Bool {
        guard preferences.isFalse(.skipPincodeSetup) else { return false }
        return !securePersistence.hasConfiguredPincode
    }
}
