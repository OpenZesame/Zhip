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
        case userFinishedChoosingWallet
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var useCase = useCaseProvider.makeWalletUseCase()

    init(presenter: Presenter?, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(presenter: presenter)
    }

    override func start() {
        toChooseWallet()
    }
}


// MARK: Private
private extension ChooseWalletCoordinator {

    func userFinishedChoosing(wallet: Wallet) {
        useCase.save(wallet: wallet)
        stepper.step(.userFinishedChoosingWallet)
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
        let coordinator = CreateNewWalletCoordinator(presenter: presenter, useCaseProvider: useCaseProvider)

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .didCreate(let wallet): self.userFinishedChoosing(wallet: wallet)
            }
        }
    }

    func toRestoreWallet() {
        let coordinator = RestoreWalletCoordinator(presenter: presenter, useCase: useCase)

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .finishedRestoring(let wallet): self.userFinishedChoosing(wallet: wallet)
            }
        }
    }

}
