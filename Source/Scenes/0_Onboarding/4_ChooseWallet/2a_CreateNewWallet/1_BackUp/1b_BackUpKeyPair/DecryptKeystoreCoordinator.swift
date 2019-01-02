//
//  DecryptKeystoreCoordinator.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
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
