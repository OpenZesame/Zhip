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
        case didRemoveWallet
    }

    private let securePersistence: SecurePersistence

    init(navigationController: UINavigationController, securePersistence: SecurePersistence) {
        self.securePersistence = securePersistence
        super.init(navigationController: navigationController)
    }

    override func start() {
        toSettings()
    }
}

// MARK: - Private
private extension SettingsCoordinator {

    func toChooseWallet() {
        securePersistence.deleteWallet()
        stepper.step(.didRemoveWallet)
    }

    func toBackupWallet() {
        guard let wallet = securePersistence.wallet else { return }
        present(type: BackupWallet.self, viewModel: BackupWalletViewModel(wallet: wallet), presentation: .present(animated: true)) { [weak self] in
            switch $0 {
            case .didBackup: self?.navigationController.dismiss(animated: true, completion: nil)
            }
        }
    }

    func toSettings() {
        present(type: Settings.self, viewModel: SettingsViewModel()) { [weak self] in
            switch $0 {
            case .removeWallet: self?.toChooseWallet()
            case .backupWallet: self?.toBackupWallet()
            }
        }
    }
}
