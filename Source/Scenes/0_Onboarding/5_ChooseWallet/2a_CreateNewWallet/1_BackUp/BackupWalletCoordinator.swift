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
