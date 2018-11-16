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

    func toChooseWallet() {
        walletUseCase.deleteWallet()
        pincodeUseCase.deletePincode()
        stepper.step(.walletWasRemovedByUser)
    }

    func toBackupWallet() {
        let viewModel = BackupWalletViewModel(useCase: walletUseCase)
        present(type: BackupWallet.self, viewModel: viewModel, presentation: .animatedPresent) { [unowned self] in
            switch $0 {
            case .userSelectedBackupIsDone: self.presenter?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func toSettings() {
        let viewModel = SettingsViewModel(useCase: pincodeUseCase)
        present(type: Settings.self, viewModel: viewModel) { [unowned self] in
            switch $0 {
            case .userSelectedSetPincode: self.stepper.step(.userWantsToSetPincode)
            case .userSelectedRemovePincode: self.stepper.step(.userWantsToRemovePincode)
            case .userSelectedBackupWallet: self.toBackupWallet()
            case .userSelectedRemoveWallet: self.toChooseWallet()
            }
        }
    }

}
