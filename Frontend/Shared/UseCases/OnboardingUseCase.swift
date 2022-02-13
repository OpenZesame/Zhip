//
//  OnboardingUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2022-02-12.
//

import Foundation
import ZhipEngine

protocol OnboardingUseCase: AnyObject {

    var hasAcceptedTermsOfService: Bool { get }
    func didAcceptTermsOfService()

    var shouldPromptUserToChosePincode: Bool { get }
}


final class DefaultOnboardingUseCase {
    private let preferences: Preferences
    let securePersistence: SecurePersistence
//    private let zilliqaService: ZilliqaServiceReactive

//    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences, securePersistence: SecurePersistence) {
//        self.zilliqaService = zilliqaService
//        self.preferences = preferences
//        self.securePersistence = securePersistence
//    }
    init(preferences: Preferences, securePersistence: SecurePersistence) {
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

extension DefaultOnboardingUseCase: OnboardingUseCase {
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
