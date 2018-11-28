//
//  MainNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame
import RxCocoa
import RxSwift

private typealias € = L10n.Scene

final class MainCoordinator: BaseCoordinator<MainCoordinator.NavigationStep> {
    enum NavigationStep {
        case removeWallet
    }

    private let useCaseProvider: UseCaseProvider
    private let deepLinkGenerator: DeepLinkGenerator
    private let deeplinkedTransaction: Driver<Transaction>

    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, deepLinkGenerator: DeepLinkGenerator, useCaseProvider: UseCaseProvider, deeplinkedTransaction: Driver<Transaction>) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkGenerator = deepLinkGenerator
        self.deeplinkedTransaction = deeplinkedTransaction
        super.init(navigationController: navigationController)
        bag <~ deeplinkedTransaction.mapToVoid().do(onNext: { [unowned self] in self.toSendPrefilTransaction() }).drive()
    }

    override func start() {
        toMain()
    }
}

//// MARK: - Deep Link Navigation
private extension MainCoordinator {
    func toSendPrefilTransaction() {
        guard childCoordinators.isEmpty else {
            log.debug("Prevented navigation to PrepareTransaction via deeplink since a coordinator is already presented.")
            return
        }
        toSend()
    }
}

// MARK: - Navigation
private extension MainCoordinator {

    func toMain() {

        let viewModel = MainViewModel(
            transactionUseCase: useCaseProvider.makeTransactionsUseCase(),
            walletUseCase: useCaseProvider.makeWalletUseCase()
        )

        push(scene: Main.self, viewModel: viewModel) { [unowned self] userIntendsTo, _ in
            switch userIntendsTo {
            case .send: self.toSend()
            case .receive: self.toReceive()
            case .goToSettings: self.toSettings()
            }
        }
    }

    func toSend() {
        presentModalCoordinator(
            makeCoordinator: { SendCoordinator(
                navigationController: $0,
                useCaseProvider: useCaseProvider,
                deeplinkedTransaction: deeplinkedTransaction
                )
        },
            navigationHandler: { userDid, dismissModalFlow in
                switch userDid {
                case .finish: dismissModalFlow(true)
                }
        })
    }

    func toReceive() {
        presentModalCoordinator(
            makeCoordinator: { ReceiveCoordinator(
                navigationController: $0,
                useCase: useCaseProvider.makeWalletUseCase(),
                deepLinkGenerator: deepLinkGenerator)
        },
            navigationHandler: { userIntendsTo, dismissModalFlow in
                switch userIntendsTo {
                case .finish: dismissModalFlow(true)
                }
        })
    }

    func toSettings() {
        presentModalCoordinator(
            makeCoordinator: { SettingsCoordinator(navigationController: $0, useCaseProvider: useCaseProvider) },
            navigationHandler: { [unowned self] userIntendsTo, dismissModalFlow in
                switch userIntendsTo {
                case .removeWallet: self.navigator.next(.removeWallet)
                case .closeSettings: dismissModalFlow(true)
                }
        })
    }
}
