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

import Combine
import Factory
import Foundation
import UIKit
import Zesame

enum BackupWalletCoordinatorNavigationStep {
    case backUp
    case cancel
}

final class BackupWalletCoordinator: BaseCoordinator<BackupWalletCoordinatorNavigationStep> {
    @Injected(\.walletStorageUseCase) private var walletStorageUseCase: WalletStorageUseCase

    private let walletOverride: AnyPublisher<Wallet, Never>?
    private let mode: BackupWalletViewModel.Mode

    private lazy var wallet: AnyPublisher<Wallet, Never> = walletOverride
        ?? walletStorageUseCase.wallet.map {
            guard let wallet = $0 else {
                incorrectImplementation("Should have saved wallet earlier")
            }
            return wallet
        }.replaceErrorWithEmpty().eraseToAnyPublisher()

    init(
        navigationController: UINavigationController,
        wallet: AnyPublisher<Wallet, Never>? = nil,
        mode: BackupWalletViewModel.Mode = .cancellable
    ) {
        self.walletOverride = wallet
        self.mode = mode
        super.init(navigationController: navigationController)
    }

    override func start(didStart _: Completion? = nil) {
        toBackUpWallet()
    }
}

// MARK: Private

private extension BackupWalletCoordinator {
    func toBackUpWallet() {
        let viewModel = BackupWalletViewModel(wallet: wallet, mode: mode)

        push(scene: BackupWallet.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .revealKeystore: self.toRevealKeystore()
            case .revealPrivateKey: self.toDecryptKeystoreToRevealKeyPair()
            case .cancelOrDismiss: self.cancel()
            case .backupWallet: self.finish()
            }
        }
    }

    func toDecryptKeystoreToRevealKeyPair() {
        presentModalCoordinator(makeCoordinator: {
            DecryptKeystoreCoordinator(navigationController: $0, wallet: wallet)
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
