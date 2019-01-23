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

    override func start(didStart: Completion? = nil) {
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
            makeCoordinator: { CreateNewWalletCoordinator(navigationController: $0, useCaseProvider: useCaseProvider) },
            navigationHandler: { [unowned self] userDid, dismissFlow in
                defer { dismissFlow(true) }
                switch userDid {
                case .create(let wallet): self.userFinishedChoosing(wallet: wallet)
                case .cancel: break
                }
        })
    }

    func toRestoreWallet() {
        presentModalCoordinator(
            makeCoordinator: { RestoreWalletCoordinator(navigationController: $0, useCase: useCase) },
            navigationHandler: { [unowned self] userDid, dismissFlow in
                defer { dismissFlow(true) }
                switch userDid {
                case .finishedRestoring(let wallet): self.userFinishedChoosing(wallet: wallet)
                case .cancel: break
                }
        })
    }

    func userFinishedChoosing(wallet: Wallet) {
        useCase.save(wallet: wallet)
        navigator.next(.finishChoosingWallet)
    }
}
