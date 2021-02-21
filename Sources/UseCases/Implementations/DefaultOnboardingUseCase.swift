// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

    var hasAnsweredCrashReportingQuestion: Bool {
        return preferences.isTrue(.hasAnsweredCrashReportingQuestion)
    }

    var hasAskedToSkipERC20Warning: Bool {
        return preferences.isTrue(.skipShowingERC20Warning)
    }

    func didAcceptTermsOfService() {
        preferences.save(value: true, for: .hasAcceptedTermsOfService)
    }

    var hasAcceptedCustomECCWarning: Bool {
        return preferences.isTrue(.hasAcceptedCustomECCWarning)
    }

    func didAcceptCustomECCWarning() {
        preferences.save(value: true, for: .hasAcceptedCustomECCWarning)
    }

    func answeredCrashReportingQuestion(acceptsCrashReporting: Bool) {
        preferences.save(value: true, for: .hasAnsweredCrashReportingQuestion)
        preferences.save(value: acceptsCrashReporting, for: .hasAcceptedCrashReporting)
        setupCrashReportingIfAllowed()
    }

    func doNotShowERC20WarningAgain() {
        preferences.save(value: true, for: .skipShowingERC20Warning)
    }

    var shouldPromptUserToChosePincode: Bool {
        guard preferences.isFalse(.skipPincodeSetup) else { return false }
        return !securePersistence.hasConfiguredPincode
    }
}
