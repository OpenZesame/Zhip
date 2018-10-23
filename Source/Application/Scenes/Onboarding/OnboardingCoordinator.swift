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

final class OnboardingCoordinator {

    private weak var navigationController: UINavigationController?
    private weak var navigator: AppNavigator?
    private let useCase: OnboardingUseCase
    private let preferences: Preferences
    private let securePersistence: SecurePersistence

    var childCoordinators = [AnyCoordinator]()

    init(navigationController: UINavigationController, navigator: AppNavigator, preferences: Preferences, securePersistence: SecurePersistence, useCase: OnboardingUseCase) {
        self.navigationController = navigationController
        self.navigator = navigator
        self.preferences = preferences
        self.securePersistence = securePersistence
        self.useCase = useCase
    }
}

extension OnboardingCoordinator: PresentingCoordinator {
    var presenter: Presenter { return navigationController! }

    func start() {
        toNextStep()
    }

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
}

// MARK: - OnboardingNavigator
/// Used for navigation between coordinators during onboarding
protocol OnboardingNavigator: Navigator {
    func toTermsOfService()
    func toWarningERC20()
    func toChooseWallet()
    func toMain(wallet: Wallet)
}

extension OnboardingCoordinator: OnboardingNavigator {

    func toTermsOfService() {
        let viewModel = TermsOfServiceViewModel(actionListener: self, useCase: useCase)
        present(TermsOfService(viewModel: viewModel))
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(actionListener: self, useCase: useCase)
        present(WarningERC20(viewModel: viewModel))
    }

    func toChooseWallet() {
        let coordinator = ChooseWalletCoordinator(
            navigationController: self.navigationController!,
            navigator: self,
            useCase: useCase.makeChooseWalletUseCase(),
            securePersistence: securePersistence
            )
        start(coordinator: coordinator, mode: .replace)
    }

    func toMain(wallet: Wallet) {
        navigator?.toMain(wallet: wallet)
    }
}

// MARK: - TermsOfServiceActionListener
extension OnboardingCoordinator: TermsOfServiceActionListener {
    func didAcceptTerms() {
        toWarningERC20()
    }
}

// MARK: - WarningERC20ActionListener
extension OnboardingCoordinator: WarningERC20ActionListener {
    func understandsERC20Risk() {
        toChooseWallet()
    }

    func doNotShowERC20WarningAgain() {
        understandsERC20Risk()
    }
}
