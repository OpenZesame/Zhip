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

final class ChooseWalletCoordinator: BaseCoordinator<ChooseWalletCoordinator.NavigationStep> {
    enum NavigationStep {
        case finishChoosingWallet
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var useCase = useCaseProvider.makeWalletUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart: CoordinatorDidStart? = nil) {
        toChooseWallet()
    }
}

// MARK: Private
private extension ChooseWalletCoordinator {

    func toChooseWallet() {
        let viewModel = ChooseWalletViewModel()

        push(scene: ChooseWallet.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .createNewWallet: self.toCreateNewWallet()
            case .restoreWallet: self.toRestoreWallet()
            }
        }
    }
    
    func toCreateNewWallet() {
        let coordinator = CreateNewWalletCoordinator(navigationController: navigationController, useCaseProvider: useCaseProvider)

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .didCreate(let wallet): self.userFinishedChoosing(wallet: wallet)
            }
        }
    }

    func toRestoreWallet() {
        let coordinator = RestoreWalletCoordinator(navigationController: navigationController, useCase: useCase)

        start(coordinator: coordinator) { [unowned self] in
            switch $0 {
            case .finishedRestoring(let wallet): self.userFinishedChoosing(wallet: wallet)
            }
        }
    }

    func userFinishedChoosing(wallet: Wallet) {
        useCase.save(wallet: wallet)
        navigator.next(.finishChoosingWallet)
    }
}
