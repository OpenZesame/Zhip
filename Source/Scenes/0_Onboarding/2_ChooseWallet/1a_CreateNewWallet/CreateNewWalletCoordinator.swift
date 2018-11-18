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

final class CreateNewWalletCoordinator: BaseCoordinator<CreateNewWalletCoordinator.Step> {
    enum Step {
        case didCreate(wallet: Wallet)
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start() {
        toCreateWallet()
    }
}

// MARK: Private
private extension CreateNewWalletCoordinator {

    func toCreateWallet() {
        let viewModel = CreateNewWalletViewModel(useCase: walletUseCase)

        push(scene: CreateNewWallet.self, viewModel: viewModel) { [unowned self] userDid, _ in
            switch userDid {
            case .createWallet(let wallet): self.toBackupWallet(wallet: wallet)
            }
        }
    }

    func toBackupWallet(wallet: Wallet) {
        let viewModel = BackupWalletViewModel(wallet: .just(wallet))

        push(scene: BackupWallet.self, viewModel: viewModel) { [unowned self] userDid, _ in
            switch userDid {
            case .backupWallet(let wallet): self.toMain(wallet: wallet)
            }
        }
    }

    func toMain(wallet: Wallet) {
        stepper.step(.didCreate(wallet: wallet))
    }

}
