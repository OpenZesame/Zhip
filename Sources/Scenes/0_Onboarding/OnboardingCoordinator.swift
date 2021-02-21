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

import UIKit
import RxSwift
import Zesame

enum OnboardingCoordinatorNavigationStep {
    case finishOnboarding
}

final class OnboardingCoordinator: BaseCoordinator<OnboardingCoordinatorNavigationStep> {

    private let useCaseProvider: UseCaseProvider
    
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toWelcome()
    }
}

private extension OnboardingCoordinator {

    func toWelcome() {
        push(scene: Welcome.self, viewModel: WelcomeViewModel()) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .start:  self.toNextStep()
            }
        }
    }

    func toNextStep() {

        guard onboardingUseCase.hasAcceptedTermsOfService else {
            return toTermsOfService()
        }

        guard onboardingUseCase.hasAnsweredCrashReportingQuestion else {
            return toAnalyticsPermission()
        }

        guard onboardingUseCase.hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        guard onboardingUseCase.hasAcceptedCustomECCWarning else {
            return toCustomECCWarning()
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
        let viewModel = TermsOfServiceViewModel(useCase: onboardingUseCase, isDismissible: false)
        push(scene: TermsOfService.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .acceptTermsOfService, .dismiss: self.toAnalyticsPermission()
            }
        }
    }

    func toAnalyticsPermission() {
        let viewModel = AskForCrashReportingPermissionsViewModel(useCase: onboardingUseCase, isDismissible: false)

        push(scene: AskForCrashReportingPermissions.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .answerQuestionAboutCrashReporting, .dismiss: self.toWarningERC20()
            }
        }
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(
            useCase: onboardingUseCase,
            mode: .userHaveToAccept(isDoNotShowAgainButtonVisible: false)
        )

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understandRisks, .dismiss: self.toCustomECCWarning()
            }
        }
    }

    func toCustomECCWarning() {
        let viewModel = WarningCustomECCViewModel(
            useCase: onboardingUseCase,
            isDismissible: false
        )

        push(scene: WarningCustomECC.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .acceptRisks, .dismiss: self.toChooseWallet()
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

        start(
            coordinator: SetPincodeCoordinator(
                navigationController: navigationController,
                useCase: useCaseProvider.makePincodeUseCase()
            )
        ) { [unowned self] (userDid: SetPincodeCoordinatorNavigationStep) in
            switch userDid {
            case .setPincode: self.finish()
            }
        }
    }

    func finish() {
        navigator.next(.finishOnboarding)
    }
}
