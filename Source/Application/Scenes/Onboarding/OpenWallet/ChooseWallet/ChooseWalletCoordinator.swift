//
//  ChooseWalletNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import Zesame

final class ChooseWalletCoordinator: AbstractCoordinator<ChooseWalletCoordinator.Step> {
    enum Step {
        case userFinishedChoosing(wallet: Wallet)
    }

    private let useCase: ChooseWalletUseCase
    private let securePersistence: SecurePersistence

    init(navigationController: UINavigationController, useCase: ChooseWalletUseCase, securePersistence: SecurePersistence) {
        self.securePersistence = securePersistence
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }

    override func start() {
        toChooseWallet()
    }
}


// MARK: Private
private extension ChooseWalletCoordinator {

    func toMain(wallet: Wallet) {
        securePersistence.save(wallet: wallet)
        stepper.step(.didChoose(wallet: wallet))
    }

    func toChooseWallet() {
        present(type: ChooseWallet.self, viewModel: ChooseWalletViewModel()) { [unowned self] in
            switch $0 {
            case .userSelectedCreateNewWallet: self.toCreateNewWallet()
            case .userSelectedRestoreWallet: self.toRestoreWallet()
            }
        }
    }

    func toCreateNewWallet() {
        start(
            coordinator:
            CreateNewWalletCoordinator(navigationController: navigationController, useCase: useCase)
        ) { [unowned self] in
            switch $0 {
            case .didCreate(let wallet): self.toMain(wallet: wallet)
            }
        }
    }

    func toRestoreWallet() {
        start(
            coordinator:
            RestoreWalletCoordinator(navigationController: navigationController, useCase: useCase)
        ) { [unowned self] in
            switch $0 {
            case .finished(.restoring(let wallet)): self.toMain(wallet: wallet)
            }
        }
    }

}
