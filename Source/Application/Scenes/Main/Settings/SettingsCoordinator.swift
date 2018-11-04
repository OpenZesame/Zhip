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
    }

    private let securePersistence: SecurePersistence

    init(navigationController: UINavigationController, securePersistence: SecurePersistence) {
        self.securePersistence = securePersistence
        super.init(presenter: navigationController)
    }

    override func start() {
        toSettings()
    }
}

// MARK: - Private
private extension SettingsCoordinator {

    func toChooseWallet() {
        securePersistence.deleteWallet()
        stepper.step(.walletWasRemovedByUser)
    }

    func toBackupWallet() {
        guard let wallet = securePersistence.wallet else { return }
        present(type: BackupWallet.self, viewModel: BackupWalletViewModel(wallet: wallet), presentation: .present(animated: true)) { [unowned self] in
            switch $0 {
            case .userSelectedBackupIsDone: self.presenter?.dismiss(animated: true)
            }
        }
    }

    func toSettings() {
        present(type: Settings.self, viewModel: SettingsViewModel()) { [unowned self] in
            switch $0 {
            case .userSelectedRemoveWallet: self.toChooseWallet()
            case .userSelectedBackupWallet: self.toBackupWallet()
            }
        }
    }
}
