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
import RxSwift
import RxCocoa
import Zesame

final class ReceiveCoordinator: BaseCoordinator<ReceiveCoordinator.NavigationStep> {
    enum NavigationStep {
        case finish
    }

    private let deepLinkGenerator: DeepLinkGenerator
    private let useCaseProvider: UseCaseProvider
    private let walletUseCase: WalletUseCase

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider, deepLinkGenerator: DeepLinkGenerator) {
        self.useCaseProvider = useCaseProvider
        self.walletUseCase = useCaseProvider.makeWalletUseCase()
        self.deepLinkGenerator = deepLinkGenerator
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toFirst()
    }
}

// MARK: - Navigate
private extension ReceiveCoordinator {

    func toFirst() {
        guard useCaseProvider.makeOnboardingUseCase().hasAskedToSkipERC20Warning else {
            return toWarningERC20()
        }

        toReceive()
    }

    func toWarningERC20() {
        let viewModel = WarningERC20ViewModel(useCase: useCaseProvider.makeOnboardingUseCase())

        push(scene: WarningERC20.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .understandRisks: self.toReceive()
            }
        }
    }
    func toReceive() {
        let viewModel = ReceiveViewModel(useCase: walletUseCase)

        push(scene: Receive.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .requestTransaction(let requestedTransaction): self.share(transaction: requestedTransaction)
            case .finish: self.finish()
            }
        }
    }

    func finish() {
        navigator.next(.finish)
    }
}

// MARK: - Share
private extension ReceiveCoordinator {
    func share(transaction: TransactionIntent) {
        let shareUrl = deepLinkGenerator.linkTo(transaction: transaction)
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.popoverPresentationController?.barButtonItem = navigationController.navigationItem.rightBarButtonItem
        navigationController.present(activityVC, animated: true, completion: nil)
    }
}
