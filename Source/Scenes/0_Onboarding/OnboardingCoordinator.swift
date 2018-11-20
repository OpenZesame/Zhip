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

final class OnboardingCoordinator: BaseCoordinator<OnboardingCoordinator.Step> {
    enum Step {
        case finishOnboarding
    }

    private let useCaseProvider: UseCaseProvider
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
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

        guard walletUseCase.hasConfiguredWallet else {
            return toChooseWallet()
        }

        guard !onboardingUseCase.shouldPromptUserToChosePincode else {
            return toChoosePincode()
        }

        finish()
    }

    func toTermsOfService() {
        let viewModel = TermsOfServiceViewModel(useCase: onboardingUseCase)

        push(scene: TermsOfService.self, viewModel: viewModel) { [unowned self] userDid, _ in
            switch userDid {
            case .acceptTermsOfService: self.toWarningERC20()
            }
        }
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(useCase: onboardingUseCase)

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid, _ in
            switch userDid {
            case .understandRisks: self.toChooseWallet()
            }
        }
    }

    func toChooseWallet() {
        let coordinator = ChooseWalletCoordinator(
            navigationController: navigationController,
            useCaseProvider: useCaseProvider
        )

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .finishChoosingWallet: self.toChoosePincode()
            }
        }
    }

    func toChoosePincode() {
        let coordinator = SetPincodeCoordinator(
            navigationController: navigationController,
            useCase: useCaseProvider.makePincodeUseCase()
        )

        start(coordinator: coordinator) { [unowned self] userDid in
            switch userDid {
            case .setPincode: self.finish()
            }
        }
    }

    func finish() {
        stepper.step(.finishOnboarding)
    }
}
