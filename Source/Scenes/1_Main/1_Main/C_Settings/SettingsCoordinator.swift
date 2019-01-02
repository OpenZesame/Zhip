//
//  SettingsCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

let githubUrlString = "https://github.com/OpenZesame/Zhip"

// This is the app id for the iOS app "Apple Store" in the iOS App Store
let appStoreUrlString = "itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"

final class SettingsCoordinator: BaseCoordinator<SettingsCoordinator.NavigationStep> {
    enum NavigationStep {
        case removeWallet
        case closeSettings
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var transactionUseCase = useCaseProvider.makeTransactionsUseCase()
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()
    private lazy var onboardingUseCase = useCaseProvider.makeOnboardingUseCase()
    private let tracker: Tracker

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, tracker: Tracker = Tracker()) {
        self.useCaseProvider = useCaseProvider
        self.tracker = tracker
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

            // Section 3
            case .backupWallet: self.toBackupWallet()
            case .removeWallet: self.toConfirmWalletRemoval()

            // Section 4
            case .openAppStore: self.toAppStore()
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
        openUrl(string: githubUrlString, tracker: tracker, context: self)
    }

    func toReportIssueOnGithub() {
        openUrl(string: githubUrlString, relative: "issues/new", tracker: tracker, context: self)
    }

    func toAcknowledgments() {
        openUrl(string: UIApplication.openSettingsURLString, tracker: tracker, context: self)
    }

    func toReadERC20Warning() {
        let viewModel = WarningERC20ViewModel(useCase: onboardingUseCase, allowedToSupress: false)

        modallyPresent(scene: WarningERC20.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .understandRisks: dismissScene(true, nil)
            }
        }
    }

    func toChangeAnalyticsPermissions() {
        let viewModel = AskForAnalyticsPermissionsViewModel(useCase: onboardingUseCase)

        modallyPresent(scene: AskForAnalyticsPermissions.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .answerQuestionAboutAnalyticsPermission: dismissScene(true, nil)
            }
        }
    }

    func toReadTermsOfService() {
        let viewModel = TermsOfServiceViewModel(useCase: onboardingUseCase)

        modallyPresent(scene: TermsOfService.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .acceptTermsOfService: dismissScene(true, nil)
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

    func toAppStore() {
        openUrl(string: appStoreUrlString, tracker: tracker, context: self)
    }

    func finish() {
        userIntends(to: .closeSettings)
    }

    func userIntends(to intention: NavigationStep) {
        navigator.next(intention)
    }
}
