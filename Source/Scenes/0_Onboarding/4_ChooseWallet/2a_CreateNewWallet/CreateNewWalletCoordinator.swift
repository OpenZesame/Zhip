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

final class CreateNewWalletCoordinator: BaseCoordinator<CreateNewWalletCoordinator.NavigationStep> {
    enum NavigationStep {
        case create(wallet: Wallet), cancel
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toEnsureThatYouAreNotBeingWatched()
    }
}

// MARK: Private
private extension CreateNewWalletCoordinator {

    func toEnsureThatYouAreNotBeingWatched() {
        let viewModel = EnsureThatYouAreNotBeingWatchedViewModel()
        push(scene: EnsureThatYouAreNotBeingWatched.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understand: self.toCreateWallet()
            case .cancel: self.cancel()
            }
        }
    }

    func toCreateWallet() {
        let viewModel = CreateNewWalletViewModel(useCase: walletUseCase)

        push(scene: CreateNewWallet.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .createWallet(let wallet): self.toBackupWallet(wallet: wallet)
            case .cancel: self.cancel()
            }
        }
    }

    func toBackupWallet(wallet: Wallet) {
        let coordinator = BackupWalletCoordinator(
            navigationController: navigationController,
            useCase: useCaseProvider.makeWalletUseCase(),
            wallet: .just(wallet)
        )

        start(coordinator: coordinator) { [unowned self] userFinished in
            switch userFinished {
            case .cancel: self.cancel()
            case .backUp: self.toMain(wallet: wallet)
            }
        }
    }

    func cancel() {
        navigator.next(.cancel)
    }

    func toMain(wallet: Wallet) {
        navigator.next(.create(wallet: wallet))
    }

}
