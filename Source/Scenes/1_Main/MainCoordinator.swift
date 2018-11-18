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
        case didRemoveWallet
    }

    private let useCaseProvider: UseCaseProvider
    private let deepLinkGenerator: DeepLinkGenerator
    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()
    private let deepLinkedTransactionSubject = PublishSubject<Transaction>()

    init(presenter: UINavigationController?, deepLinkGenerator: DeepLinkGenerator, useCaseProvider: UseCaseProvider, lockApp: Driver<Void>) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkGenerator = deepLinkGenerator
        super.init(presenter: presenter)
        bag <~ lockApp.do(onNext: { [unowned self] in
            self.toUnlockAppWithPincodeIfNeeded()
        }).drive()
    }

    override func start() {
        toMain()
    }
}

// MARK: - Deep Link Navigation
extension MainCoordinator {
    func toSendPrefilTransaction(_ transaction: Transaction) {
        deepLinkedTransactionSubject.onNext(transaction)
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
                presenter: $0,
                useCaseProvider: useCaseProvider,
                deepLinkedTransaction: deepLinkedTransactionSubject.asDriverOnErrorReturnEmpty()
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
                presenter: $0,
                useCase: useCaseProvider.makeWalletUseCase(),
                deepLinkGenerator: deepLinkGenerator)
        },
            navigationHandler: { userIntendsTo, dismissModalFlow in
                switch userIntendsTo {
                case .finish: dismissModalFlow(true)
                }
        })
    }

    func toUnlockAppWithPincodeIfNeeded() {
        guard pincodeUseCase.hasConfiguredPincode, !isCurrentlyPresentingUnlockScene else { return }

        let viewModel = UnlockAppWithPincodeViewModel(useCase: pincodeUseCase)
        modallyPresent(
            scene: UnlockAppWithPincode.self,
            viewModel: viewModel
        ) { userDid, dismissScene in
            switch userDid {
            case .unlockApp: dismissScene(true)
            }
        }
    }

    func toSettings() {
        presentModalCoordinator(
            makeCoordinator: { SettingsCoordinator(presenter: $0, useCaseProvider: useCaseProvider) },
            navigationHandler: { [unowned self] userIntendsTo, dismissModalFlow in
                switch userIntendsTo {
                case .removeWallet: self.stepper.step(.didRemoveWallet)
                case .closeSettings: dismissModalFlow(true)
                }
        })
    }
}

private extension MainCoordinator {
    var isCurrentlyPresentingUnlockScene: Bool {
        guard let last = childCoordinators.last, type(of: last) == SetPincodeCoordinator.self else {
            return false
        }
        return true
    }
}
