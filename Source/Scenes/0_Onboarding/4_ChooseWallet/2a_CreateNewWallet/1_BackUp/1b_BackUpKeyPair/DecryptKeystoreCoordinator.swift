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

final class DecryptKeystoreCoordinator: BaseCoordinator<DecryptKeystoreCoordinator.NavigationStep> {
    enum NavigationStep {
        case /* "user finished" */ backingUpKeyPair, dismiss
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
        toDecryptKeystore()
    }
}

// MARK: Private
private extension DecryptKeystoreCoordinator {

    func toDecryptKeystore() {
        let viewModel = DecryptKeystoreToRevealKeyPairViewModel(useCase: useCase, wallet: wallet)

        push(scene: DecryptKeystoreToRevealKeyPair.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .dismiss: self.dismiss()
            case .decryptKeystoreReavealing(let keyPair): self.toBackUpRevealed(keyPair: keyPair)
            }
        }
    }

    func toBackUpRevealed(keyPair: KeyPair) {
        let viewModel = BackUpRevealedKeyPairViewModel(keyPair: keyPair)

        push(scene: BackUpRevealedKeyPair.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .finish: self.finish()
            }
        }
    }

    func dismiss() {
        navigator.next(.dismiss)
    }

    func finish() {
        let userFinished: NavigationStep = .backingUpKeyPair
        navigator.next(userFinished)
    }

}
