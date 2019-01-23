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
    private let deeplinkedTransaction: Driver<TransactionIntent>
    private let updateBalanceSubject = PublishSubject<Void>()

    private lazy var pincodeUseCase = useCaseProvider.makePincodeUseCase()

    init(navigationController: UINavigationController, deepLinkGenerator: DeepLinkGenerator, useCaseProvider: UseCaseProvider, deeplinkedTransaction: Driver<TransactionIntent>) {
        self.useCaseProvider = useCaseProvider
        self.deepLinkGenerator = deepLinkGenerator
        self.deeplinkedTransaction = deeplinkedTransaction
        super.init(navigationController: navigationController)
        bag <~ deeplinkedTransaction.mapToVoid().do(onNext: { [unowned self] in self.toSendPrefilTransaction() }).drive()
    }

    override func start(didStart: Completion? = nil) {
        toMain(didStart: didStart)
    }
}

//// MARK: - Deep Link Navigation
private extension MainCoordinator {
    func toSendPrefilTransaction() {
        guard childCoordinators.isEmpty else {
            // Prevented navigation to PrepareTransaction via deeplink since a coordinator is already presented
            return
        }
        toSend()
    }
}

// MARK: - Navigation
private extension MainCoordinator {

    func toMain(didStart: Completion? = nil) {

        let viewModel = MainViewModel(
            transactionUseCase: useCaseProvider.makeTransactionsUseCase(),
            walletUseCase: useCaseProvider.makeWalletUseCase(),
            updateBalanceTrigger: updateBalanceSubject.asDriverOnErrorReturnEmpty()
        )

        push(scene: Main.self, viewModel: viewModel, navigationPresentationCompletion: didStart) { [unowned self] userIntendsTo in
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
            navigationHandler: { [unowned self] userDid, dismissModalFlow in
                switch userDid {
                case .finish(let triggerBalanceFetching):
                    if triggerBalanceFetching {
                        self.triggerFetchingOfBalance()
                    }
                    dismissModalFlow(true)
                }
        })
    }

    func toReceive() {
        presentModalCoordinator(
            makeCoordinator: { ReceiveCoordinator(
                navigationController: $0,
                useCaseProvider: useCaseProvider,
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

// MARK: - Private
private extension MainCoordinator {
    func triggerFetchingOfBalance() {
        updateBalanceSubject.onNext(())
    }
}
