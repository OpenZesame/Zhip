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

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider) {
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

    func toMain(wallet: Wallet) {
        stepper.step(.didCreate(wallet: wallet))
    }

    func toBackupWallet(wallet: Wallet) {
        let viewModel = BackupWalletViewModel(useCase: walletUseCase)
        present(type: BackupWallet.self, viewModel: viewModel) { [unowned self] in
            switch $0 {
            case .userSelectedBackupIsDone(let wallet): self.toMain(wallet: wallet)
            }
        }
    }

    func toCreateWallet() {
        present(
            type: CreateNewWallet.self,
            viewModel: CreateNewWalletViewModel(useCase: walletUseCase)
        ) { [unowned self] in
            switch $0 {
            case .userInitiatedCreationOfWallet(let wallet): self.toBackupWallet(wallet: wallet)
            }
        }
    }
}
