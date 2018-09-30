//
//  OnboardingUseCase.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift

protocol OnboardingUseCase {

    func didAcceptTermsOfService()
    func doNotShowERC20WarningAgain()
    func makeChooseWalletUseCase() -> ChooseWalletUseCase
    
}
