//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
