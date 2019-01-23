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

import Foundation

import UIKit
import Zesame

import RxSwift
import RxCocoa

final class BackupWalletCoordinator: BaseCoordinator<BackupWalletCoordinator.NavigationStep> {
    enum NavigationStep {
        case backUp
        case cancel
    }

    private let useCase: WalletUseCase
    private let wallet: Driver<Wallet>

    init(navigationController: UINavigationController, useCase: WalletUseCase, wallet: Driver<Wallet>? = nil) {
        self.useCase = useCase
        if let wallet = wallet {
            self.wallet = wallet
        } else {
            self.wallet = useCase.wallet.map {
                guard let wallet = $0 else {
                    incorrectImplementation("Should have saved wallet earlier")
                }
                return wallet
            }.asDriverOnErrorReturnEmpty()
        }
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toBackUpWallet()
    }
}

// MARK: Private
private extension BackupWalletCoordinator {

    func toBackUpWallet() {

        let viewModel = BackupWalletViewModel(wallet: wallet)

        push(scene: BackupWallet.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .revealKeystore: self.toRevealKeystore()
            case .revealPrivateKey: self.toDecryptKeystoreToRevealKeyPair()
            case .cancel: self.cancel()
            case .backupWallet: self.finish()
            }
        }
    }

    func toDecryptKeystoreToRevealKeyPair() {
        presentModalCoordinator(makeCoordinator: {
            DecryptKeystoreCoordinator(navigationController: $0, useCase: useCase, wallet: wallet)
        }, navigationHandler: { userFinished, dismissModalFlow in
                switch userFinished {
                case .backingUpKeyPair: dismissModalFlow(true)
                case .dismiss: dismissModalFlow(true)
                }
        })
    }

    func toRevealKeystore() {
        let viewModel = BackUpKeystoreViewModel(wallet: wallet)

        modallyPresent(scene: BackUpKeystore.self, viewModel: viewModel) { userDid, dismissScene in
            switch userDid {
            case .finished: dismissScene(true, nil)
            }
        }
    }

    func cancel() {
        navigator.next(.cancel)
    }

    func finish() {
        let userFinished: NavigationStep = .backUp
        navigator.next(userFinished)
    }

}
