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
