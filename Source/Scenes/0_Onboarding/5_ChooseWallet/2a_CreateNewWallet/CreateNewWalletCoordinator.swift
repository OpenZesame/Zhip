// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
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
