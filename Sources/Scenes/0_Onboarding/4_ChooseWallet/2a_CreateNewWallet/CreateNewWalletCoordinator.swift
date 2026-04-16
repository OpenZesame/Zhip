//
// MIT License
//
// Copyright (c) 2018-2026 Open Zesame (https://github.com/OpenZesame)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import RxCocoa
import RxSwift
import UIKit
import Zesame

enum CreateNewWalletCoordinatorNavigationStep {
    case create(wallet: Wallet), cancel
}

final class CreateNewWalletCoordinator: BaseCoordinator<CreateNewWalletCoordinatorNavigationStep> {
    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart _: Completion? = nil) {
        toEnsureThatYouAreNotBeingWatched()
    }
}

// MARK: Private

private extension CreateNewWalletCoordinator {
    func toEnsureThatYouAreNotBeingWatched() {
        let viewModel = EnsureThatYouAreNotBeingWatchedViewModel()
        push(scene: EnsureThatYouAreNotBeingWatched.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understand: toCreateWallet()
            case .cancel: cancel()
            }
        }
    }

    func toCreateWallet() {
        let viewModel = CreateNewWalletViewModel(useCase: walletUseCase)

        push(scene: CreateNewWallet.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case let .createWallet(wallet): toBackupWallet(wallet: wallet)
            case .cancel: cancel()
            }
        }
    }

    func toBackupWallet(wallet: Wallet) {
        start(
            coordinator: BackupWalletCoordinator(
                navigationController: navigationController,
                useCase: useCaseProvider.makeWalletUseCase(),
                wallet: Driver.just(wallet)
            )
        ) { [unowned self] userFinished in
            switch userFinished {
            case .cancel: cancel()
            case .backUp: toMain(wallet: wallet)
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
