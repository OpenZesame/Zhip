//
//  DefaultOnboardingUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import Zesame

final class DefaultOnboardingUseCase {
    private let preferences: Preferences
    let securePersistence: SecurePersistence
    private let zilliqaService: ZilliqaServiceReactive

    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences, securePersistence: SecurePersistence) {
        self.zilliqaService = zilliqaService
        self.preferences = preferences
        self.securePersistence = securePersistence
    }
}

extension DefaultOnboardingUseCase: OnboardingUseCase {
    var hasAcceptedTermsOfService: Bool {
        return preferences.isTrue(.hasAcceptedTermsOfService)
    }

    var hasAnsweredAnalyticsPermissionsQuestion: Bool {
        return preferences.isTrue(.hasAnsweredAnalyticsPermissionsQuestion)
    }

    var hasAskedToSkipERC20Warning: Bool {
        return preferences.isTrue(.skipShowingERC20Warning)
    }

    func didAcceptTermsOfService() {
        preferences.save(value: true, for: .hasAcceptedTermsOfService)
    }

    func answeredAnalyticsPermissionsQuestion(acceptsTracking: Bool) {
        preferences.save(value: true, for: .hasAnsweredAnalyticsPermissionsQuestion)
        preferences.save(value: acceptsTracking, for: .hasAcceptedAnalyticsTracking)
        setupAnalyticsIfAllowed()
    }

    func doNotShowERC20WarningAgain() {
        preferences.save(value: true, for: .skipShowingERC20Warning)
    }

    var shouldPromptUserToChosePincode: Bool {
        guard preferences.isFalse(.skipPincodeSetup) else { return false }
        return !securePersistence.hasConfiguredPincode
    }
}
