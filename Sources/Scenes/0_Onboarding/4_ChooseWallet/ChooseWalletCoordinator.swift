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

import Factory
import UIKit
import Zesame

enum ChooseWalletCoordinatorNavigationStep {
    case finishChoosingWallet
}

final class ChooseWalletCoordinator: BaseCoordinator<ChooseWalletCoordinatorNavigationStep> {
    @Injected(\.walletStorageUseCase) private var walletStorageUseCase: WalletStorageUseCase

    override func start(didStart _: Completion? = nil) {
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
        presentModalCoordinator(
            makeCoordinator: { CreateNewWalletCoordinator(navigationController: $0) },
            navigationHandler: { [unowned self] userDid, dismissFlow in
                defer { dismissFlow(true) }
                switch userDid {
                case let .create(wallet): self.userFinishedChoosing(wallet: wallet)
                case .cancel: break
                }
            }
        )
    }

    func toRestoreWallet() {
        presentModalCoordinator(
            makeCoordinator: { RestoreWalletCoordinator(navigationController: $0) },
            navigationHandler: { [unowned self] userDid, dismissFlow in
                defer { dismissFlow(true) }
                switch userDid {
                case let .finishedRestoring(wallet): self.userFinishedChoosing(wallet: wallet)
                case .cancel: break
                }
            }
        )
    }

    func userFinishedChoosing(wallet: Wallet) {
        walletStorageUseCase.save(wallet: wallet)
        navigator.next(.finishChoosingWallet)
    }
}
