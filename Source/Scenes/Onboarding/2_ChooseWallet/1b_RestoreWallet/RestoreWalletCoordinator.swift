//
//  RestoreWalletNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class RestoreWalletCoordinator: BaseCoordinator<RestoreWalletCoordinator.Step> {
    enum Step {
        case finishedRestoring(wallet: Wallet)
    }

    private let useCase: WalletUseCase

    init(presenter: Presenter?, useCase: WalletUseCase) {
        self.useCase = useCase
        super.init(presenter: presenter)
    }

    override func start() {
        toRestoreWallet()
    }
}

// MARK: - Private
private extension RestoreWalletCoordinator {

    func toMain(restoredWallet: Wallet) {
        stepper.step(.finishedRestoring(wallet: restoredWallet))
    }

    func toRestoreWallet() {
        present(type: RestoreWallet.self, viewModel: RestoreWalletViewModel(useCase: useCase)) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .restoreWallet(let wallet): self.toMain(restoredWallet: wallet)
            }
        }
    }
}
