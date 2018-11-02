//
//  OnboardingCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import Zesame

final class OnboardingCoordinator: AbstractCoordinator<OnboardingCoordinator.Step> {
    enum Step {
        case didChoose(wallet: Wallet)
    }

    private let useCase: OnboardingUseCase
    private let preferences: Preferences
    private let securePersistence: SecurePersistence

    init(navigationController: UINavigationController, preferences: Preferences, securePersistence: SecurePersistence, useCase: OnboardingUseCase) {
        self.preferences = preferences
        self.securePersistence = securePersistence
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }

    override func start() {
        toNextStep()
    }
}

private extension OnboardingCoordinator {

    func toNextStep() {
        guard preferences.isTrue(.hasAcceptedTermsOfService) else {
            return toTermsOfService()
        }

        guard preferences.isTrue(.skipShowingERC20Warning) else {
            return toWarningERC20()
        }

        guard let wallet = securePersistence.wallet else {
            return toChooseWallet()
        }
        
        toMain(wallet: wallet)
    }

    func toTermsOfService() {
        present(type: TermsOfService.self, viewModel: TermsOfServiceViewModel()) { [unowned self] in
            switch $0 {
            case .didAcceptTerms:
                self.useCase.didAcceptTermsOfService()
                self.toWarningERC20()
            }
        }
    }

    func toWarningERC20() {
        present(type: WarningERC20.self, viewModel: WarningERC20ViewModel()) { [unowned self] in
            switch $0 {
            case .understandsRisksSkipWarningFromNowOn:
                self.useCase.doNotShowERC20WarningAgain()
                fallthrough
            case .understandsRisks: self.toChooseWallet()
            }
        }
    }

    func toChooseWallet() {
        start(
            coordinator:
            ChooseWalletCoordinator(
                navigationController: navigationController,
                useCase: useCase.makeChooseWalletUseCase(),
                securePersistence: securePersistence
            )
        ) { [unowned stepper] in
            switch $0 {
            case .didChoose(let wallet): stepper.step(.didChoose(wallet: wallet))
            }
        }
    }

    func toMain(wallet: Wallet) {
        stepper.step(.didChoose(wallet: wallet))
    }
}
