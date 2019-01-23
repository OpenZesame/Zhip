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
