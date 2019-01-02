//
//  OnboardingUseCase.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift

protocol OnboardingUseCase: AnyObject {

    var hasAcceptedTermsOfService: Bool { get }
    func didAcceptTermsOfService()

    var hasAnsweredAnalyticsPermissionsQuestion: Bool { get }
    func answeredAnalyticsPermissionsQuestion(acceptsTracking: Bool)

    var hasAskedToSkipERC20Warning: Bool { get }
    func doNotShowERC20WarningAgain()

    var shouldPromptUserToChosePincode: Bool { get }
}
