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
import RxCocoa
import Zesame

let githubUrlString = "https://github.com/OpenZesame/Zhip"

enum SettingsCoordinatorNavigationStep {
    case removeWallet
    case closeSettings
}

final class SettingsCoordinator: BaseCoordinator<SettingsCoordinatorNavigationStep> {
  
    private let useCaseProvider: UseCaseProvider
    private lazy var transactionUseCase = useCaseProvider.makeTransactionsUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toSettings()
    }
}

// MARK: - Navigate
private extension SettingsCoordinator {

    // swiftlint:disable:next cyclomatic_complexity
    func toSettings() {
        let viewModel = SettingsViewModel(useCase: pincodeUseCase)

        push(scene: Settings.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            // Navigation bar
            case .closeSettings: self.finish()

            // Section 0
            case .removePincode: self.toRemovePincode()
            case .setPincode: self.toSetPincode()

            // Section 1
            case .starUsOnGithub: self.toStarUsOnGitHub()
            case .reportIssueOnGithub: self.toReportIssueOnGithub()
            case .acknowledgments: self.toAcknowledgments()

            // Section 2
            case .readTermsOfService: self.toReadTermsOfService()
            case .readERC20Warning: self.toReadERC20Warning()
            case .changeAnalyticsPermissions: self.toChangeAnalyticsPermissions()
            case .readCustomECCWarning: self.toReadCustomECCWarning()

            // Section 3
            case .backupWallet: self.toBackupWallet()
            case .removeWallet: self.toConfirmWalletRemoval()
            }
        }
    }

    func toRemovePincode() {
        let viewModel = RemovePincodeViewModel(useCase: pincodeUseCase)

        modallyPresent(scene: RemovePincode.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .cancelPincodeRemoval, .removePincode: dismissScene(true, nil)
            }
        }
    }

    func toSetPincode() {
        presentModalCoordinator(
            makeCoordinator: { SetPincodeCoordinator(navigationController: $0, useCase: useCaseProvider.makePincodeUseCase()) },
            navigationHandler: { userDid, dismissModalFlow in
                switch userDid {
                case .setPincode: dismissModalFlow(true)
                }
        })
    }

    func toStarUsOnGitHub() {
        openUrl(string: githubUrlString)
    }

    func toReportIssueOnGithub() {
        openUrl(string: githubUrlString, relative: "issues/new")
    }

    func toAcknowledgments() {
        openUrl(string: UIApplication.openSettingsURLString)
    }

    func toReadERC20Warning() {
        let viewModel = WarningERC20ViewModel(
            useCase: onboardingUseCase,
            mode: .dismissible
        )

        let warningErc20 = WarningERC20(viewModel: viewModel, navigationBarLayout: .opaque)

        modallyPresent(scene: warningErc20) { userDid, dismissScene in
            switch userDid {
            case .understandRisks, .dismiss: dismissScene(true, nil)
            }
        }
    }

    func toChangeAnalyticsPermissions() {
        let viewModel = AskForCrashReportingPermissionsViewModel(useCase: onboardingUseCase, isDismissible: true)
        let scene = AskForCrashReportingPermissions(viewModel: viewModel, navigationBarLayout: .opaque)

        modallyPresent(scene: scene) { userDid, dismissScene in
            switch userDid {
            case .answerQuestionAboutCrashReporting, .dismiss: dismissScene(true, nil)
            }
        }
    }

    func toReadTermsOfService() {
        let viewModel = TermsOfServiceViewModel(useCase: onboardingUseCase, isDismissible: true)
        let termsOfService = TermsOfService(viewModel: viewModel, navigationBarLayout: .opaque)
        modallyPresent(scene: termsOfService) { userDid, dismissScene in
            switch userDid {
            case .acceptTermsOfService, .dismiss: dismissScene(true, nil)
            }
        }
    }

    func toReadCustomECCWarning() {
        let viewModel = WarningCustomECCViewModel(
            useCase: onboardingUseCase,
            isDismissible: true
        )

        let scene = WarningCustomECC(viewModel: viewModel, navigationBarLayout: .opaque)

        modallyPresent(scene: scene) { userDid, dismissScene in
            switch userDid {
            case .acceptRisks, .dismiss: dismissScene(true, nil)
            }
        }
    }

    func toBackupWallet() {
        presentModalCoordinator(
            makeCoordinator: { BackupWalletCoordinator(navigationController: $0, useCase: walletUseCase)
        },
            navigationHandler: { userFinished, dismissModalFlow in
                switch userFinished {
                case .cancel, .backUp: dismissModalFlow(true)
            }
        })
    }

    func toConfirmWalletRemoval() {
        let viewModel = ConfirmWalletRemovalViewModel(useCase: walletUseCase)

        modallyPresent(scene: ConfirmWalletRemoval.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .cancel: dismissScene(true, nil)
            case .confirm:
                dismissScene(true) { [unowned self] in
                    self.toChooseWallet()
                }
            }
        }
    }

    func toChooseWallet() {
        transactionUseCase.deleteCachedBalance()
        walletUseCase.deleteWallet()
        pincodeUseCase.deletePincode()
        userIntends(to: .removeWallet)
    }

    func finish() {
        userIntends(to: .closeSettings)
    }

    func userIntends(to intention: NavigationStep) {
        navigator.next(intention)
    }
}
