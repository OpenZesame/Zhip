//
//  SettingsCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

final class SettingsCoordinator: BaseCoordinator<SettingsCoordinator.Step> {
    enum Step {
//        case managePincode(intent: ManagePincodeCoordinator.Intent)
        case removeWallet
        case closeSettings
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
        toSettings()
    }

    override func start() {}
}

// MARK: - Navigate
private extension SettingsCoordinator {

    func toSettings() {
        let viewModel = SettingsViewModel(useCase: pincodeUseCase)
        present(type: Settings.self, viewModel: viewModel, presentation: .none) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .closeSettings: self.finish()
            case .setPincode: self.toSetPincode()
            case .removePincode: self.toRemovePincode()
            case .backupWallet: self.toBackupWallet()
            case .removeWallet: self.toChooseWallet()
            }
        }
    }

    func toSetPincode() {
        toPincode(intent: .setPincode)
    }

    func toRemovePincode() {
        toPincode(intent: .unlockApp(toRemovePincode: true))
    }

    func toChooseWallet() {
        walletUseCase.deleteWallet()
        pincodeUseCase.deletePincode()
        userIntends(to: .removeWallet)
    }

    func toBackupWallet() {
        let viewModel = BackupWalletViewModel(useCase: walletUseCase)
        present(type: BackupWallet.self, viewModel: viewModel, presentation: .animatedPresent) { [unowned self] userDid in
            switch userDid {
            case .backupWallet: self.presenter?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func toPincode(intent: ManagePincodeCoordinator.Intent) {
        presentModalCoordinator(
            makeCoordinator: { ManagePincodeCoordinator(intent: intent, presenter: $0, useCase: useCaseProvider.makePincodeUseCase()) },
            navigationHandler: { userDid, dismissModalFlow in
                switch userDid {
                case .finish: dismissModalFlow(true)
                }
        })
    }

    func finish() {
        userIntends(to: .closeSettings)
    }

    func userIntends(to intention: Step) {
        stepper.step(intention)
    }

}
