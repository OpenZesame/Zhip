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
    private let zilliqaService: ZilliqaServiceReactive

    init(zilliqaService: ZilliqaServiceReactive, preferences: Preferences) {
        self.zilliqaService = zilliqaService
        self.preferences = preferences
    }
}

extension DefaultOnboardingUseCase: OnboardingUseCase {

    func didAcceptTermsOfService() {
        preferences.save(value: true, for: .hasAcceptedTermsOfService)
    }

    func doNotShowERC20WarningAgain() {
        preferences.save(value: true, for: .skipShowingERC20Warning)
    }

    func makeChooseWalletUseCase() -> ChooseWalletUseCase {
        return DefaultChooseWalletUseCase(zilliqaService: zilliqaService)
    }
}
