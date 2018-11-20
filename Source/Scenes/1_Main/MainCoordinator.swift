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

final class MainCoordinator: BaseCoordinator<MainCoordinator.Step> {
    enum Step {
        case removeWallet
    }

    private let useCaseProvider: UseCaseProvider
    private let deepLinkGenerator: DeepLinkGenerator

    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, deepLinkGenerator: DeepLinkGenerator, useCaseProvider: UseCaseProvider, deeplinkedTransaction: Driver<Transaction>) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkGenerator = deepLinkGenerator
        super.init(navigationController: navigationController)
        bag <~ deeplinkedTransaction.do(onNext: { [unowned self] in
            self.toSendPrefilTransaction($0)
        }).drive()
    }

    override func start() {
        toMain()
    }
}

// MARK: - Deep Link Navigation
extension MainCoordinator {
    func toSendPrefilTransaction(_ transaction: Transaction) {
        if let sendCoordinator = anyCoordinatorOf(type: SendCoordinator.self) {
            sendCoordinator.prefillTranscaction(transaction)
        } else {
            toSend(prefillTransaction: transaction)
        }
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

    func toSend(prefillTransaction: Transaction? = nil) {
        presentModalCoordinator(
            makeCoordinator: { SendCoordinator(
                navigationController: $0,
                useCaseProvider: useCaseProvider,
                prefilledTransaction: prefillTransaction
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
                case .removeWallet: self.stepper.step(.removeWallet)
                case .closeSettings: dismissModalFlow(true)
                }
        })
    }
}
