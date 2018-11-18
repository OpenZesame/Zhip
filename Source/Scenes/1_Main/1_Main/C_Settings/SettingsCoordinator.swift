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
        case removeWallet
        case closeSettings
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start() {
        toSettings()
    }
}

// MARK: - Navigate
private extension SettingsCoordinator {

    func toSettings() {
        let viewModel = SettingsViewModel(useCase: pincodeUseCase)

        push(scene: Settings.self, viewModel: viewModel) { [unowned self] userIntendsTo, _ in
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
        presentModalCoordinator(
            makeCoordinator: { SetPincodeCoordinator(navigationController: $0, useCase: useCaseProvider.makePincodeUseCase()) },
            navigationHandler: { userDid, dismissModalFlow in
                switch userDid {
                case .setPincode: dismissModalFlow(true)
                }
        })
    }

    func toRemovePincode() {
        let viewModel = RemovePincodeViewModel(useCase: pincodeUseCase)

        modallyPresent(scene: RemovePincode.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .cancelPincodeRemoval, .removePincode: dismissScene(true)
            }
        }
    }

    func toChooseWallet() {
        walletUseCase.deleteWallet()
        pincodeUseCase.deletePincode()
        userIntends(to: .removeWallet)
    }

    func toBackupWallet() {
        guard let wallet = walletUseCase.loadWallet() else {
            incorrectImplementation("Should have a wallet")
        }

        let viewModel = BackupWalletViewModel(wallet: .just(wallet))

        modallyPresent(scene: BackupWallet.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .backupWallet: dismissScene(true)
            }
        }
    }

    func finish() {
        userIntends(to: .closeSettings)
    }

    func userIntends(to intention: Step) {
        stepper.step(intention)
    }

}
