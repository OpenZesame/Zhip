//
//  DefaultOnboardingUseCase.swift
//  Zupreme
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

    var hasOptedForAnalyticsPermissions: Bool {
        return preferences.hasValue(for: .hasAcceptedAnalyticsTracking)
    }

    var hasAskedToSkipERC20Warning: Bool {
        return preferences.isTrue(.skipShowingERC20Warning)
    }

    func didAcceptTermsOfService() {
        preferences.save(value: true, for: .hasAcceptedTermsOfService)
    }

    func optedForAnalyticsPermissions(acceptsTracking: Bool) {
        preferences.save(value: acceptsTracking, for: .hasAcceptedAnalyticsTracking)
    }

    func doNotShowERC20WarningAgain() {
        preferences.save(value: true, for: .skipShowingERC20Warning)
    }

    var shouldPromptUserToChosePincode: Bool {
        guard preferences.isFalse(.skipPincodeSetup) else { return false }
        return !securePersistence.hasConfiguredPincode
    }
}
