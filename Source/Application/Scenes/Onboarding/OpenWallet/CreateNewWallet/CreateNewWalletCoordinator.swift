//
//  CreateNewWalletCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

import RxSwift
import RxCocoa

final class CreateNewWalletCoordinator: AbstractCoordinator<CreateNewWalletCoordinator.Step> {

    private let useCase: ChooseWalletUseCase

    init(navigationController: UINavigationController, useCase: ChooseWalletUseCase) {
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }

    override func start() {
        toCreateWallet()
    }
}

extension CreateNewWalletCoordinator {
    enum Step {
        case didCreate(wallet: Wallet)
    }

}

// MARK: Private
private extension CreateNewWalletCoordinator {

    func toMain(wallet: Wallet) {
        stepper.step(.didCreate(wallet: wallet))
    }

    func toBackupWallet(wallet: Wallet) {
        present(type: BackupWallet.self, viewModel: BackupWalletViewModel(wallet: wallet)) { [unowned self] in
            switch $0 {
            case .didBackup(let wallet): self.toMain(wallet: wallet)
            }
        }
    }

    func toCreateWallet() {
        present(
            type: CreateNewWallet.self,
            viewModel: CreateNewWalletViewModel(useCase: useCase)
        ) { [unowned self] in
            switch $0 {
            case .(let wallet): self.toBackupWallet(wallet: wallet)
            }
        }
    }
}
