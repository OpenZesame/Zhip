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

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(presenter: UINavigationController?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
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

    func toCreateWallet() {
        present(
            scene: CreateNewWallet.self,
            viewModel: CreateNewWalletViewModel(useCase: walletUseCase)
        ) { [unowned self] userDid in
            switch userDid {
            case .createWallet(let wallet): self.toBackupWallet(wallet: wallet)
            }
        }
    }

    func toBackupWallet(wallet: Wallet) {
        let viewModel = BackupWalletViewModel(wallet: .just(wallet))
        present(scene: BackupWallet.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .backupWallet(let wallet): self.toMain(wallet: wallet)
            }
        }
    }

    func toMain(wallet: Wallet) {
        stepper.step(.didCreate(wallet: wallet))
    }

}
