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
        case userFinishedOnboording
    }

    private let useCaseProvider: UseCaseProvider
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
    }

    override func start() {
        toNextStep()
    }
}

private extension OnboardingCoordinator {

    func toNextStep() {
        guard onboardingUseCase.hasAcceptedTermsOfService else {
            return toTermsOfService()
        }

        guard onboardingUseCase.hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        guard walletUseCase.hasWalletConfigured else {
            return toChooseWallet()
        }

        finish()
    }

    func toTermsOfService() {
        present(type: TermsOfService.self, viewModel: TermsOfServiceViewModel()) { [unowned self] in
            switch $0 {
            case .userAcceptedTerms:
                self.onboardingUseCase.didAcceptTermsOfService()
                self.toWarningERC20()
            }
        }
    }

    func toWarningERC20() {
        present(type: WarningERC20.self, viewModel: WarningERC20ViewModel()) { [unowned self] in
            switch $0 {
            case .userSelectedRisksAreUnderstoodDoNotShowAgain:
                self.onboardingUseCase.doNotShowERC20WarningAgain()
                fallthrough
            case .userSelectedRisksAreUnderstood: self.toChooseWallet()
            }
        }
    }

    func toChooseWallet() {
        let coordinator = ChooseWalletCoordinator(
            presenter: presenter,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .userFinishedChoosingWallet: self.finish()
            }
        }
    }

    func finish() {
        stepper.step(.userFinishedOnboording)
    }
}
