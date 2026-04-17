// MIT License — Copyright (c) 2018-2026 Open Zesame

import Foundation

protocol OnboardingUseCase: AnyObject {
    var hasAcceptedTermsOfService: Bool { get }
    func didAcceptTermsOfService()

    var hasAcceptedCustomECCWarning: Bool { get }
    func didAcceptCustomECCWarning()

    var hasAnsweredCrashReportingQuestion: Bool { get }
    func answeredCrashReportingQuestion(acceptsCrashReporting: Bool)

    var shouldPromptUserToChosePincode: Bool { get }
}
