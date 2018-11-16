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

final class SettingsCoordinator: AbstractCoordinator<SettingsCoordinator.Step> {
    enum Step {
        case walletWasRemovedByUser
        case userWantsToSetPincode
        case userWantsToRemovePincode
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
    }

    override func start() {
        toSettings()
    }
}

// MARK: - Navigate
private extension SettingsCoordinator {

    func toSettings() {
        let viewModel = SettingsViewModel(useCase: pincodeUseCase)
        present(type: Settings.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .setPincode: self.toSetPincode()
            case .removePincode: self.toRemovePincode()
            case .backupWallet: self.toBackupWallet()
            case .removeWallet: self.toChooseWallet()
            }
        }
    }

    func toSetPincode() {
        stepper.step(.userWantsToSetPincode)
    }

    func toRemovePincode() {
        stepper.step(.userWantsToRemovePincode)
    }

    func toChooseWallet() {
        walletUseCase.deleteWallet()
        pincodeUseCase.deletePincode()
        stepper.step(.walletWasRemovedByUser)
    }

    func toBackupWallet() {
        let viewModel = BackupWalletViewModel(useCase: walletUseCase)
        present(type: BackupWallet.self, viewModel: viewModel, presentation: .animatedPresent) { [unowned self] userDid in
            switch userDid {
            case .backupWallet: self.presenter?.dismiss(animated: true, completion: nil)
            }
        }
    }



}
